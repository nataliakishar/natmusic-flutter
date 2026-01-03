// services/storage_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class StorageService {
  static Future<String> saveFile(File file) async {
    final dir = await getApplicationDocumentsDirectory();
    final musicDir = Directory('${dir.path}/musicas');

    if (!musicDir.existsSync()) {
      musicDir.createSync(recursive: true);
    }

    final newPath = join(musicDir.path, basename(file.path));
    return file.copy(newPath).then((f) => f.path);
  }
}
