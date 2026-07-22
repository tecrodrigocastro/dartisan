import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../core/http/api_client.dart';
import 'publish_token_models.dart';

class PublishTokenRepository {
  final ApiClient _client;

  PublishTokenRepository(this._client);

  Future<List<PublishToken>> list() async {
    try {
      final response = await _client.dio.get('/api/publish-tokens/');
      return (response.data as List)
          .map((json) => PublishToken.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<PublishTokenCreated> create() async {
    try {
      final response = await _client.dio.post('/api/publish-tokens/');
      return PublishTokenCreated.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> revoke(int id) async {
    try {
      await _client.dio.delete('/api/publish-tokens/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
