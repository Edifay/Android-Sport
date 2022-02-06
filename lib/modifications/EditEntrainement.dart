import 'package:flutter/material.dart';
import 'package:secondtry/Contener/EntrainementManager.dart';
import 'package:secondtry/Sport/Entrainement.dart';
import 'package:secondtry/Sport/Action.dart' as a;
import 'package:secondtry/modifications/CreateNewAction.dart';
import 'package:secondtry/modifications/EditAction.dart';
import 'package:secondtry/modifications/Menu.dart';

import '../PageEntrainement.dart';

// ignore: must_be_immutable
class EditMenu extends StatefulWidget {
  Entrainement entre;

  EditMenu(this.entre, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  EditMenuState createState() {
    return EditMenuState(this.entre);
  }
}

class EditMenuState extends State<EditMenu> {
  Entrainement entre;
  List<Widget> actionsWidget = [];

  update(bool withSetState) {
    List<Widget> widgets = [];
    for (int i = 0; i < this.entre.actions.length; i++) {
      var act = this.entre.actions[i];
      print(width);
      widgets.add(
        InkWell(
          key: Key('$i'),
          onTap: () {
            editAction(act);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Container(
              height:
                  ((textSize(act.name, TextStyle(fontSize: 30)).width + 40) /
                              (width - 100))
                          .ceilToDouble() *
                      textSize(act.name, TextStyle(fontSize: 30)).height,
              child: Stack(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          deleteAction(act);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.copy_outlined),
                        onPressed: () {
                          entre.actions.insert(i, act.clone());
                          update(true);
                          saveEntrainement();
                        },
                      ),
                      Container(
                        width: width-106,
                        child: Text(
                          act.name,
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${act.time}sc',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (withSetState) {
      setState(() {
        this.actionsWidget = widgets.toList();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        menuState.update(true);
      });
    } else
      this.actionsWidget = widgets.toList();
  }

  EditMenuState(this.entre) {
    update(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modification de ${entre.name}"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) newIndex -= 1;
                    if (oldIndex == entre.actions.length) return;
                    if (newIndex == entre.actions.length) newIndex--;
                    final act = entre.actions.removeAt(oldIndex);
                    entre.actions.insert(newIndex, act);
                    update(true);
                    saveEntrainement();
                  },
                  children: getListAfterModification()),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Modifier',
        child: Text('${((entre.duration) / 60).round()}min'),
      ),
    );
  }

  void deleteAction(a.Action action) {
    entre.removeAction(action);
    saveEntrainement();
    update(true);
  }

  List<Widget> getListAfterModification() {
    List<Widget> atReturn = actionsWidget.toList();
    atReturn.add(Center(
      key: Key('${atReturn.length}'),
      child: IconButton(icon: Icon(Icons.add), onPressed: addNewAction),
    ));
    for (var act in atReturn) {
      print(act.key);
    }
    return atReturn;
  }

  void addNewAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateAction(this)));
  }

  void addAction(a.Action action) {
    entre.addAction(action);
    update(true);
    saveEntrainement();
  }

  void editAction(a.Action action) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditAction(this, action)));
  }

  void replaceAction(a.Action old, a.Action neue) {
    print(entre.actions.indexOf(old));
    entre.actions[entre.actions.indexOf(old)] = neue;
    update(true);
    saveEntrainement();
  }

  Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
