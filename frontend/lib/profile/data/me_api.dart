import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../core/http/api_client.dart';
import 'me_models.dart';

class MeApi {
  final ApiClient _client;

  MeApi(this._client);

  Future<Me> getMe() async {
    try {
      final response = await _client.dio.get('/api/me');
      return Me.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
