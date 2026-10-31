import 'dart:io';

import 'package:vaden/vaden.dart';

abstract class PackageStorage {
  Future<Stream<List<int>>> read(String path);
  Future<void> write(String path, Stream<List<int>> data);
}

// Só o provider `local` é implementado por enquanto (s3/firebase ficam para
// quando o roadmap pedir, a interface já não deve exigir mudar o controller).
@Component()
class LocalPackageStorage implements PackageStorage {
  final String _folder;

  LocalPackageStorage(ApplicationSettings settings)
    : _folder = settings['storage']['local']['folder'] as String;

  /// Rejeita caminhos que escapariam de [_folder] (defesa em profundidade:
  /// o validador já restringe o nome do pacote, mas o storage não deve
  /// depender disso).
  File _resolve(String path) {
    final segments = path.split(RegExp(r'[\\/]'));
    final unsafe = path.isEmpty ||
        path.startsWith('/') ||
        path.contains('\\') ||
        segments.any((s) => s.isEmpty || s == '.' || s == '..');
    if (unsafe) {
      throw ArgumentError.value(path, 'path', 'Caminho de storage inválido');
    }
    return File('$_folder/$path');
  }

  @override
  Future<Stream<List<int>>> read(String path) async {
    final file = _resolve(path);
    if (!await file.exists()) {
      throw FileSystemException('Package archive not found', file.path);
    }
    return file.openRead();
  }

  @override
  Future<void> write(String path, Stream<List<int>> data) async {
    final file = _resolve(path);
    await file.create(recursive: true);
    final sink = file.openWrite();
    await sink.addStream(data);
    await sink.close();
  }
}
