import 'package:vaden/vaden.dart';

import 'admin_dto.dart';
import 'admin_service.dart';
import 'app_user_details.dart';

// Protegido pelo catch-all AnyRequest().authenticated() do HttpSecurity; a
// checagem de role 'admin' é feita no AdminService.
@Api(tag: 'Admin', description: 'Gestão de usuários e permissões (admin)')
@Controller('/api/admin')
class AdminController {
  final AdminService _service;

  AdminController(this._service);

  @Get('/users')
  Future<List<AdminUserDTO>> listUsers(
    @Context('user') AppUserDetails currentUser,
  ) {
    return _service.listUsers(currentUser);
  }

  @Put('/users/<id>/role')
  Future<Map<String, dynamic>> updateRole(
    @Context('user') AppUserDetails currentUser,
    @Param('id') int id,
    @Body() UpdateRoleRequestDTO body,
  ) async {
    await _service.updateRole(currentUser, id, body.role);
    return {'success': true};
  }
}
