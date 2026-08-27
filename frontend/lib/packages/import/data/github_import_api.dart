import 'package:dio/dio.dart';

import '../../../core/error/api_exception.dart';
import '../../../core/http/api_client.dart';
import 'github_import_models.dart';

class GithubImportApi {
  final ApiClient _client;

  GithubImportApi(this._client);

  /// A URL de autorização do GitHub. Precisa vir via XHR autenticado (não um
  /// redirect de navegação inteira) porque a rota exige o header
  /// Authorization — ver comentário em GithubConnectController no backend.
  Future<String> getConnectUrl() async {
    try {
      final response = await _client.dio.get('/api/github/connect');
      return (response.data as Map<String, dynamic>)['url'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<bool> getConnectionStatus() async {
    try {
      final response = await _client.dio.get('/api/github/connection');
      return (response.data as Map<String, dynamic>)['connected'] as bool;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<GithubRepo>> listRepos() async {
    try {
      final response = await _client.dio.get('/api/github/repos');
      return (response.data as List)
          .map((json) => GithubRepo.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<GithubRefs> listRefs(String owner, String repo) async {
    try {
      final response = await _client.dio.get('/api/github/repos/$owner/$repo/refs');
      return GithubRefs.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Devolve o nome do pacote publicado (do pubspec.yaml, pode diferir do
  /// nome do repo) — usado pra navegar direto pra `/packages/<nome>`.
  Future<String> importPackage({
    required String owner,
    required String repo,
    required String ref,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/github/import',
        data: {'owner': owner, 'repo': repo, 'ref': ref},
      );
      return (response.data as Map<String, dynamic>)['package_name'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
