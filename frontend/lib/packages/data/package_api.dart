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
}
