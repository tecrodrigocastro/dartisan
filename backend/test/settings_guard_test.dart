import 'package:backend/config/settings_guard.dart';
import 'package:test/test.dart';

void main() {
  const strongSecret = 'um-segredo-bem-longo-com-mais-de-32-caracteres';

  test('modo debug aceita os valores padrão', () {
    expect(
      findUnsafeSettings(
        mode: 'debug',
        securitySecret: defaultSecuritySecret,
        postgresPassword: defaultPostgresPassword,
      ),
      isEmpty,
    );
  });

  test('fora do debug rejeita segredo e senha padrão', () {
    final problems = findUnsafeSettings(
      mode: 'production',
      securitySecret: defaultSecuritySecret,
      postgresPassword: defaultPostgresPassword,
    );
    expect(problems, hasLength(2));
    expect(
      () => assertSafeSettings(
        mode: 'production',
        securitySecret: defaultSecuritySecret,
        postgresPassword: defaultPostgresPassword,
      ),
      throwsStateError,
    );
  });

  test('fora do debug rejeita segredo curto', () {
    expect(
      findUnsafeSettings(
        mode: 'production',
        securitySecret: 'curto',
        postgresPassword: 'senha-forte-do-banco',
      ),
      hasLength(1),
    );
  });

  test('fora do debug aceita valores fortes', () {
    expect(
      findUnsafeSettings(
        mode: 'production',
        securitySecret: strongSecret,
        postgresPassword: 'senha-forte-do-banco',
      ),
      isEmpty,
    );
    expect(
      () => assertSafeSettings(
        mode: 'production',
        securitySecret: strongSecret,
        postgresPassword: 'senha-forte-do-banco',
      ),
      returnsNormally,
    );
  });
}
