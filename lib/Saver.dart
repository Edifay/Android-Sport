import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get getLocalPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> getLocalFile(final String fileName) async {
  final path = await getLocalPath;
  return File('$path/$fileName.txt');
}

void write(File file, String data) {
  file.writeAsStringSync(data);
}

String read(File file) {
  if (file.existsSync())
    return file.readAsStringSync();
  else
    return null;
}