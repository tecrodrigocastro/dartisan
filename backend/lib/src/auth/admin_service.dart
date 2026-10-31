import 'package:vaden/vaden.dart';

import 'admin_dto.dart';
import 'app_user_details.dart';
import 'user_repository.dart';

const assignableRoles = {'admin', 'publisher', 'reader'};

abstract class AdminService {
  Future<List<AdminUserDTO>> listUsers(AppUserDetails actor);
  Future<void> updateRole(AppUserDetails actor, int userId, String role);
}

@Service()
class AdminServiceImpl implements AdminService {
  final UserRepository _users;

  AdminServiceImpl(this._users);

  @override
  Future<List<AdminUserDTO>> listUsers(AppUserDetails actor) async {
    _requireAdmin(actor);
    final users = await _users.listAll();
    return users
        .map(
          (u) => AdminUserDTO(
            id: u.id,
            username: u.username,
            role: u.role,
            createdAt: u.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateRole(AppUserDetails actor, int userId, String role) async {
    _requireAdmin(actor);

    if (!assignableRoles.contains(role)) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'invalid_role',
          'message': 'Role deve ser uma de: admin, publisher, reader',
        },
      });
    }
    // Evita o admin se trancar para fora ao rebaixar a si mesmo.
    if (actor.id == userId && role != 'admin') {
      throw ResponseException.badRequest({
        'error': {
          'code': 'cannot_demote_self',
          'message': 'Você não pode remover seu próprio acesso de admin',
        },
      });
    }

    final updated = await _users.updateRole(userId, role);
    if (!updated) {
      throw ResponseException.notFound({
        'error': {'code': 'not_found', 'message': 'Usuário não encontrado'},
      });
    }
  }

  void _requireAdmin(AppUserDetails actor) {
    if (!actor.roles.contains('admin')) {
      throw ResponseException(403, {
        'error': {
          'code': 'forbidden',
          'message': 'Apenas administradores podem fazer isso',
        },
      });
    }
  }
}
