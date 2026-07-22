import 'package:dio/dio.dart';

/// Erro de API já traduzido do corpo padrão do backend
/// (`{"error": {"code": ..., "message": ...}}`).
class ApiException implements Exception {
  final String code;
  final String message;

  const ApiException({required this.code, required this.message});

  factory ApiException.fromDioError(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['error'] is Map) {
      final body = data['error'] as Map;
      return ApiException(
        code: body['code'] as String? ?? 'unknown_error',
        message: body['message'] as String? ?? 'Erro desconhecido',
      );
    }

    return ApiException(
      code: 'network_error',
      message: error.message ?? 'Falha de conexão com o servidor',
    );
  }

  @override
  String toString() => message;
}
