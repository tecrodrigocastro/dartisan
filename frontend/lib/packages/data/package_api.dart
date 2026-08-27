import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../core/http/api_client.dart';
import 'package_models.dart';

class PackageRepository {
  final ApiClient _client;

  PackageRepository(this._client);

  Future<PackageMetadata> getMetadata(String name) async {
    try {
      final response = await _client.dio.get('/api/packages/$name');
      return PackageMetadata.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<PackageList> listRecent({int limit = 12, int offset = 0}) async {
    try {
      final response = await _client.dio.get(
        '/api/packages',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      return PackageList.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<PackageSummary>> getMine() async {
    try {
      final response = await _client.dio.get('/api/me/packages');
      return (response.data as List)
          .map((json) => PackageSummary.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<PackageSummary>> getLikedByMe() async {
    try {
      final response = await _client.dio.get('/api/me/likes');
      return (response.data as List)
          .map((json) => PackageSummary.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Alterna o like do usuário autenticado nesse pacote. Devolve o novo
  /// estado e a contagem já atualizada, num round-trip só.
  Future<(bool liked, int count)> toggleLike(String name) async {
    try {
      final response = await _client.dio.post('/api/packages/$name/likes');
      final data = response.data as Map<String, dynamic>;
      return (data['liked'] as bool, data['count'] as int);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<bool> isLikedByMe(String name) async {
    try {
      final response = await _client.dio.get('/api/me/packages/$name/like');
      return (response.data as Map<String, dynamic>)['liked'] as bool;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
