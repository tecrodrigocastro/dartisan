import 'package:vaden/vaden.dart';

import 'publish_service.dart';

// Passos 3.2/3.3 não exigem Authorization — a identidade já foi resolvida
// no passo 3.1 e carregada pela UploadSession (mesmo padrão da pub
// repository spec v2: URL de upload "temporária/assinada").
@Api(
  tag: 'Publish',
  description: 'Fluxo de publicação de pacotes (dart pub publish)',
)
@Controller('/api/packages/versions')
class PublishController {
  final PublishService _service;
  final ApplicationSettings _settings;

  PublishController(this._service, this._settings);

  int get _maxTarballSizeBytes =>
      _settings['publish']['max_tarball_size_bytes'] as int;

  String get _baseUrl => _settings['env']['base_url'] as String;

  @Get('/new')
  Future<Map<String, dynamic>> newUpload(
    @Header('Authorization') String? authorization,
  ) async {
    final session = await _service.startUpload(authorization);
    return {
      'url': '$_baseUrl/api/packages/versions/newUpload?upload=${session.id}',
      'fields': <String, dynamic>{},
    };
  }

  @Post('/newUpload')
  Future<Response> upload(
    Request request,
    @Query('upload') String? uploadId,
  ) async {
    if (uploadId == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'invalid_session',
          'message': 'Parâmetro "upload" ausente na URL',
        },
      });
    }

    final form = request.formData();
    if (form == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'invalid_request',
          'message': 'Corpo da requisição não é multipart/form-data',
        },
      });
    }

    List<int>? fileBytes;
    await for (final field in form.formData) {
      if (field.name == 'file') {
        fileBytes = await field.part.readBytes();
      }
    }

    if (fileBytes == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'invalid_request',
          'message': 'Campo "file" ausente no multipart',
        },
      });
    }

    await _service.attachTarball(
      uploadId,
      fileBytes,
      maxSizeBytes: _maxTarballSizeBytes,
    );

    return Response.found(
      '$_baseUrl/api/packages/versions/newUploadFinish?upload=$uploadId',
    );
  }

  @Get('/newUploadFinish')
  Future<Map<String, dynamic>> finish(@Query('upload') String? uploadId) async {
    if (uploadId == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'invalid_session',
          'message': 'Parâmetro "upload" ausente na URL',
        },
      });
    }

    await _service.finishUpload(uploadId, maxSizeBytes: _maxTarballSizeBytes);

    return {
      'success': {'message': 'Pacote publicado com sucesso'},
    };
  }
}
