import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../core/http/auth_api_client.dart';
import 'auth_models.dart';

class AuthApi {
  final AuthApiClient _client;

  AuthApi(this._client);

  Future<Tokenization> login(String username, String password) async {
    try {
      final response = await _client.dio.post(
        '/api/auth/login',
        data: {'username': username, 'password': password},
      );
      return Tokenization.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Tokenization> refresh(String refreshToken) async {
    try {
      final response = await _client.dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return Tokenization.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _client.dio.post(
        '/api/auth/logout',
        data: {'refresh_token': refreshToken},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
