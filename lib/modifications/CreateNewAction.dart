import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:secondtry/Sport/Action.dart' as a;
import 'package:secondtry/modifications/EditEntrainement.dart';

// ignore: must_be_immutable
class CreateAction extends StatefulWidget {
  EditMenuState parent;

  CreateAction(this.parent, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  CreateActionState createState() {
    return CreateActionState(this.parent);
  }
}

class CreateActionState extends State<CreateAction> {
  bool repos = false;
  String name = "Nom";
  int time = 45;
  EditMenuState parent;

  bool editing = false;

  bool enable = true;

  update(bool withSetState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.parent.update(true);
    });
  }

  CreateActionState(this.parent) {
    update(false);
  }

  void changedTextField(String str) {
    name = str;
  }

  void longPress() {
    if (!enable) return;
    editing = !editing;
    setState(() {});
  }

  void validate(String str) {
    if (!enable) return;
    if (str == "") return;
    name = str;
    editing = !editing;
    setState(() {});
  }

  void changed(bool actual) {
    repos = !repos;
    if (repos) {
      name = "Repos";
      enable = false;
    } else {
      enable = true;
    }
    setState(() {});
  }

  int minutes = 0;
  int secondes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Création d'une action"),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: GestureDetector(
                      onLongPress: longPress,
                      onDoubleTap: longPress,
                      child: editing
                          ? TextField(onSubmitted: validate, onChanged: changedTextField, controller: TextEditingController()..text = name,)
                          : Text(
                              '${this.name}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 50),
                            ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  'Repos:',
                                  style: TextStyle(fontSize: 30),
                                ),
                                Switch(value: repos, onChanged: changed),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                        child: Column(children: [
                          Row(
                            children: [
                              Text('Temps:'),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Container(
                                  width: 65,
                                  child: TextButton(
                                    onPressed: eventOnMinutes,
                                    child: Text('${minutes}min'),
                                  ),
                                ),
                              ),
                              Container(
                                width: 53,
                                child: TextButton(
                                    onPressed: eventOnSecond,
                                    child: Text('${secondes}sc')),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  parent.addAction(repos
                      ? new a.Repos(minutes * 60 + secondes)
                      : new a.Action(name, minutes * 60 + secondes));
                  Navigator.pop(context);
                },
                child: Text('Créer', style: TextStyle(fontSize: 25),),
              ),
            )
          ],
        ));
  }

  void eventOnSecond() {
    showMaterialNumberPicker(
        maxLongSide: 400,
        selectedNumber: secondes,
        context: context,
        minNumber: 0,
        maxNumber: 1000,
        step: 5,
        title: 'Durée en seconde',
        cancelText: 'Annuler',
        confirmText: 'Comfirmer',
        onChanged: (a) {
          secondes = a;
        },
        onConfirmed: () {
          while (secondes >= 60) {
            minutes++;
            secondes -= 60;
          }
          setState(() {});
        });
  }

  void eventOnMinutes() {
    showMaterialNumberPicker(
        maxLongSide: 400,
        selectedNumber: minutes,
        context: context,
        minNumber: 0,
        maxNumber: 120,
        step: 1,
        title: 'Durée en minutes',
        cancelText: 'Annuler',
        confirmText: 'Comfirmer',
        onChanged: (a) {
          minutes = a;
        },
        onConfirmed: () {
          setState(() {});
        });
  }
}
