import 'package:backend/src/auth/admin_bootstrap.dart';
import 'package:backend/src/auth/admin_service.dart';
import 'package:backend/src/auth/app_user_details.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'publish_test.dart' show FakeUserRepository;

void main() {
  final encoder = BCryptPasswordEncoder(cost: 4); // cost baixo, é teste

  group('AdminBootstrap', () {
    late FakeUserRepository users;

    setUp(() => users = FakeUserRepository());

    AdminBootstrap bootstrap(Map<String, String> env) =>
        AdminBootstrap.withEnv(users, encoder, env);

    test('sem variáveis de ambiente não cria ninguém', () async {
      await bootstrap({}).ensure();
      expect(users.users, isEmpty);
    });

    test('cria o admin com a senha informada quando não existe', () async {
      await bootstrap({'ADMIN_USERNAME': 'red', 'ADMIN_PASSWORD': 'segredo'})
          .ensure();

      final admin = await users.findByUsername('red');
      expect(admin, isNotNull);
      expect(admin!.role, 'admin');
      expect(encoder.matches('segredo', admin.passwordHash!), isTrue);
    });

    test('promove usuário existente sem trocar a senha', () async {
      final existing = await users.createPasswordUser(
        username: 'red',
        passwordHash: encoder.encode('original'),
        role: 'reader',
      );

      await bootstrap({'ADMIN_USERNAME': 'red', 'ADMIN_PASSWORD': 'outra'})
          .ensure();

      final updated = await users.findById(existing.id);
      expect(updated!.role, 'admin');
      expect(encoder.matches('original', updated.passwordHash!), isTrue);
    });

    test('é idempotente', () async {
      final b = bootstrap({'ADMIN_USERNAME': 'red', 'ADMIN_PASSWORD': 'x'});
      await b.ensure();
      await b.ensure();
      expect(users.users, hasLength(1));
    });
  });

  group('AdminService', () {
    late FakeUserRepository users;
    late AdminServiceImpl service;
    late AppUserDetails admin;
    late AppUserDetails publisher;

    setUp(() async {
      users = FakeUserRepository();
      service = AdminServiceImpl(users);
      await users.createPasswordUser(
          username: 'admin', passwordHash: 'h', role: 'admin');
      await users.createPasswordUser(
          username: 'ana', passwordHash: 'h', role: 'reader');
      admin = AppUserDetails(
          id: 1, username: 'admin', password: '', roles: ['admin']);
      publisher = AppUserDetails(
          id: 2, username: 'ana', password: '', roles: ['publisher']);
    });

    Matcher status(int code) =>
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', code));

    test('não-admin recebe 403', () async {
      await expectLater(() => service.listUsers(publisher), status(403));
      await expectLater(
          () => service.updateRole(publisher, 2, 'admin'), status(403));
    });

    test('admin altera a role de outro usuário', () async {
      await service.updateRole(admin, 2, 'publisher');
      expect((await users.findById(2))!.role, 'publisher');
    });

    test('role inválida retorna 400', () async {
      await expectLater(() => service.updateRole(admin, 2, 'root'), status(400));
    });

    test('usuário inexistente retorna 404', () async {
      await expectLater(
          () => service.updateRole(admin, 99, 'publisher'), status(404));
    });

    test('admin não pode rebaixar a si mesmo', () async {
      await expectLater(
          () => service.updateRole(admin, 1, 'reader'), status(400));
    });
  });
}
