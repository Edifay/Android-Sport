import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:secondtry/Sport/Action.dart' as a;
import 'package:secondtry/modifications/EditEntrainement.dart';

// ignore: must_be_immutable
class EditAction extends StatefulWidget {
  EditMenuState parent;
  a.Action action;

  EditAction(this.parent, this.action, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  EditActionState createState() {
    return EditActionState(this.parent, this.action);
  }
}

class EditActionState extends State<EditAction> {
  bool repos = false;
  String name = "Nom";
  EditMenuState parent;
  a.Action action;

  bool editing = false;

  bool enable = true;

  update(bool withSetState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.parent.update(true);
    });
  }

  EditActionState(this.parent, this.action) {
    repos = this.action is a.Repos;
    this.name = this.action.name;
    secondes = this.action.time;
    while (secondes >= 60) {
      minutes++;
      secondes -= 60;
    }

    update(false);
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

  void changedTextField(String str) {
    name = str;
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
    return WillPopScope(
        child: Scaffold(
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
                              ? TextField(
                                  onSubmitted: validate,
                                  onChanged: changedTextField,
                                  controller: TextEditingController()
                                    ..text = name,
                                )
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
                    onPressed: validateChanges,
                    child: Text(
                      'Modifier',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                )
              ],
            )),
        onWillPop: () {
          validateChanges();
          return Future<bool>.value(true);
        });
  }

  void validateChanges() {
    parent.replaceAction(
        this.action,
        repos
            ? new a.Repos(minutes * 60 + secondes)
            : new a.Action(name, minutes * 60 + secondes));
    Navigator.pop(context);
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
