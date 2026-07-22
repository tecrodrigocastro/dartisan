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

  @override
  Future<Stream<List<int>>> read(String path) async {
    final file = File('$_folder/$path');
    if (!await file.exists()) {
      throw FileSystemException('Package archive not found', file.path);
    }
    return file.openRead();
  }

  @override
  Future<void> write(String path, Stream<List<int>> data) async {
    final file = File('$_folder/$path');
    await file.create(recursive: true);
    final sink = file.openWrite();
    await sink.addStream(data);
    await sink.close();
  }
}
