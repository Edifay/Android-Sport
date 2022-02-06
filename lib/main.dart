import 'package:flutter/material.dart';
import 'package:secondtry/Contener/EntrainementManager.dart';
import 'package:secondtry/Sport/Action.dart' as a;
import 'package:secondtry/Sport/Entrainement.dart';
import 'PageEntrainement.dart';

double volume = 0.5;

void main() async {

  runApp(MyApp());
  int numberOfEntrainementLoaded = await loadEntrainement();
  print('There is $numberOfEntrainementLoaded entrainements loaded !');
  if (numberOfEntrainementLoaded == 0) {
    List<a.Action> actions = [a.Repos(45)];
    addEntrainement(Entrainement("Lundi", actions: actions.toList()));
    actions.add(a.Repos(165));
    actions.add(a.Action("Crunch", 125));
    actions.add(a.Repos(45));
    actions.add(a.Action("Jumping Jacks", 45));
    addEntrainement(Entrainement("Mardi", actions: actions));
  }
  state.updateEntrainement();
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}