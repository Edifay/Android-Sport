import 'dart:convert';
import 'dart:io';
import 'package:secondtry/PageEntrainement.dart';
import 'package:secondtry/Saver.dart';
import 'package:secondtry/Sport/Entrainement.dart';

List<Entrainement> entrainements = [];
String fileName = 'entrainements.json';

Future<int> loadEntrainement() async {
  entrainements =
      (json.decode(read(await getLocalFile(fileName)) ?? "[]") as List<dynamic>)
          .map((e) => Entrainement.fromJson(e))
          .toList();
  return entrainements.length;
}

Future<int> saveEntrainement() async {
  write(await getLocalFile(fileName), jsonEncode(entrainements));
  return entrainements.length;
}

bool loadOneEntrainement(File file){
  try {
    String data = file.readAsStringSync();
    print('data : $data');
    entrainements.add(Entrainement.fromJson(json.decode(data)));
    print('loaded');
    saveEntrainement();
  } on Exception{
    return false;
  }
  return true;
}

void addEntrainement(Entrainement entre) {
  entrainements.add(entre);
  saveEntrainement();
  state.updateEntrainement();
}

void removeEntrainement(Entrainement entre) {
  entrainements.remove(entre);
  saveEntrainement();
  state.updateEntrainement();
}
