import 'dart:convert';
import 'dart:io';

class DocReaderService {
  final String filename;
  final Future<Directory> Function() getDirectory;

  DocReaderService(this.getDirectory, this.filename);
// In DocReaderService
Future<dynamic> readFromDisk() async {
  try {
    final file = await _getLocalFile();
    if (!await file.exists()) return {};
    final string = await file.readAsString();
    return jsonDecode(string);
  } catch (e) {
    print('Error reading file: $e');
    return {}; // Return empty instead of crashing
  }
}

  Future<File> writeToDisk(String json) async {
    final file = await _getLocalFile();

    return file.writeAsString(json);
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/$filename.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}
