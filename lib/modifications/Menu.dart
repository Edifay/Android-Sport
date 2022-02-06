import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondtry/Contener/EntrainementManager.dart';
import 'package:secondtry/PageEntrainement.dart';
import 'package:secondtry/Sport/Entrainement.dart';
import 'package:secondtry/SportPlayer/Play.dart';
import 'package:secondtry/modifications/EditEntrainement.dart';

MenuState menuState;

// ignore: must_be_immutable
class Menu extends StatefulWidget {
  Entrainement entre;

  Menu(this.entre, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  MenuState createState() {
    menuState = MenuState(this.entre);
    return menuState;
  }
}

class MenuState extends State<Menu> {
  Entrainement entre;
  List<Widget> actionsWidget;
  Text widgetText;
  TextField widgetTextField;
  bool editing = false;

  update(bool withSetState) {
    List<Widget> widgets = this.entre.actions.map((e) {
      print(textSize(e.name, TextStyle(fontSize: 30)).height);
      return Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Container(
          height: ((textSize(e.name, TextStyle(fontSize: 30)).width + 40) /
                      (width - 50))
                  .ceilToDouble() *
              textSize(e.name, TextStyle(fontSize: 30)).height,
          child: Stack(
            children: [
              Center(
                child: Text(
                  e.name,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${e.time}sc',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
    if (withSetState) {
      setState(() {
        this.actionsWidget = widgets.toList();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        state.updateEntrainement();
      });
    } else
      this.actionsWidget = widgets.toList();
  }

  MenuState(this.entre) {
    update(false);
    this.widgetText = Text(
      '${this.entre.name}',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 50),
    );
    widgetTextField = TextField(onSubmitted: validate,  controller: TextEditingController()..text = entre.name,);
  }

  void longPress() {
    editing = !editing;
    setState(() {});
  }

  void validate(String str) {
    if (str == "") return;
    entre.setName = str;
    saveEntrainement();
    state.updateEntrainement();
    widgetText = Text(
      str,
      style: TextStyle(fontSize: 50),
    );
    editing = !editing;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de l'entrainement"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                deleteDialogConfirm(context);
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: GestureDetector(
                    onLongPress: longPress,
                    onDoubleTap: longPress,
                    child: editing ? widgetTextField : widgetText,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    'Cet entrainement dure ${((entre.duration) / 60).round()} minutes.',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: ElevatedButton(
                      onPressed: start, child: Text('Commencer')),
                ),
                Expanded(
                  child: ListView(children: actionsWidget),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: edit,
        tooltip: 'Modifier',
        child: Icon(Icons.edit),
      ),
    );
  }

  void edit() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditMenu(entre)));
  }

  void start() {
    if (entre.actions.length <= 0) {
      Fluttertoast.showToast(
          msg: "Vous n'avez pas ajouté d'action !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Player(entre)));
  }

  void deleteDialogConfirm(BuildContext context) {
    AlertDialog alert;
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
        removeEntrainement(entre);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    alert = AlertDialog(
      title: Text("Suppression d'un entrainement"),
      content: Text("Voulez-vous vraiment suppriemr cet entraînement ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
