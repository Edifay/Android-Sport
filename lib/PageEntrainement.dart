import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondtry/Contener/EntrainementManager.dart';
import 'package:secondtry/Sport/Entrainement.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Saver.dart';
import 'main.dart';
import 'modifications/Menu.dart';

HomeState state;

double width = 0;

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomeState createState() {
    state = HomeState();
    return state;
  }
}

void _askCameraPermission() async {
  if (await Permission.storage.request().isGranted) {
    print(await Permission.storage.status);
  }
}

class HomeState extends State<Home> {
  List<Widget> entrainementsWidget = [];

  void updateEntrainement() {
    width = MediaQuery.of(context).size.width;
    List<Widget> buffer = [];
    print("Update called : ${entrainements.length}");
    for (int i = 0; i < entrainements.length; i++) {
      var entre = entrainements[i];
      buffer.add(
        Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: new InkWell(
            onLongPress: () async {
              File file =
                  new File('/storage/emulated/0/Download/${entre.name}.entre');
              _askCameraPermission();
              write(file, jsonEncode(entre));
              Fluttertoast.showToast(
                  msg: "Entrainement ajouté au téléchargements !",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Menu(entre)),
              );
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 50,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      entre.name,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${(entre.duration / 60).round()}min',
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
    setState(() {
      entrainementsWidget = buffer.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.surround_sound_outlined),
              onPressed: () {
                changeVolume(context);
              }),
          IconButton(
            icon: Icon(Icons.upload_rounded),
            onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles();
              if (result != null) {
                if (loadOneEntrainement(new File(result.files.first.path))) {
                  Fluttertoast.showToast(
                      msg: "Le fichier a été chargé !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Fluttertoast.showToast(
                      msg: "Le fichier n'a pas pu être chargé !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                updateEntrainement();
              }
            },
          ),
        ],
        title: Text('Vos entrainements !'),
        centerTitle: true,
      ),
      body: ListView(
        children: entrainementsWidget,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewEntrainement,
        tooltip: 'Nouveau entrainement',
        child: Icon(Icons.add_outlined),
      ),
    );
  }

  void changeVolume(BuildContext context) {
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Changer le volume"),
              content: Center(
                child: Column(
                  children: [
                    Text('Volume:'),
                    Row(
                      children: [
                        Text('${volume.toStringAsFixed(2)}'),
                        Slider(
                          value: volume,
                          max: 1,
                          min: 0,
                          onChanged: (value) {
                            print('value: ${value.toStringAsFixed(3)}');
                            setState(() {
                              volume = value;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                continueButton,
              ],
            );
          },
        );
      },
    );
  }

  void addNewEntrainement() =>
      addEntrainement(new Entrainement("Nouveau Entrainement"));
}
