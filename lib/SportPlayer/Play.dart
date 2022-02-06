import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondtry/Sport/Entrainement.dart';

import '../main.dart';

AudioPlayer advancedPlayer = AudioPlayer();
AudioCache player = new AudioCache(fixedPlayer: advancedPlayer);

// ignore: must_be_immutable
class Player extends StatefulWidget {
  Entrainement entre;

  Player(this.entre, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  PlayerState createState() {
    return PlayerState(this.entre);
  }
}

class PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  bool disp = false;
  double actualNumber = 0;
  Entrainement entre;
  int actionNumber;
  bool isPlaying = false;
  Animation<double> alpha;
  AnimationController controller;
  bool reStart = false;

  final alarmAudioPath = "end.mp4";

  PlayerState(this.entre) {
    this.actionNumber = 0;
    controller = AnimationController(
        duration:
            Duration(milliseconds: entre.actions[actionNumber].time * 1000),
        vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          player.play(alarmAudioPath, volume: volume);
          changePlayer();
          isPlaying = false;
          skip();
        }
      });
    alpha = Tween<double>(
            begin: 0, end: entre.actions[actionNumber].time.roundToDouble())
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });
  }

  void skip() {
    if (actionNumber < entre.actions.length - 1) {
      if (isPlaying) changePlayer();
      actionNumber++;
      actualNumber = 0;
      controller.duration =
          Duration(milliseconds: entre.actions[actionNumber].time * 1000);
      alpha = Tween<double>(
              begin: 0, end: entre.actions[actionNumber].time.roundToDouble())
          .animate(controller)
            ..addListener(() {
              setState(() {});
            });
      changePlayer();
    } else {
      disposeTimer();
      Navigator.pop(context);
    }
  }

  void prev() {
    if (actionNumber > 0) {
      if (isPlaying) changePlayer();
      actionNumber--;
      actualNumber = 0;
      controller.duration =
          Duration(milliseconds: entre.actions[actionNumber].time * 1000);
      alpha = Tween<double>(
              begin: 0, end: entre.actions[actionNumber].time.roundToDouble())
          .animate(controller)
            ..addListener(() {
              setState(() {});
            });
      changePlayer();
    }
  }

  void startChange(double value) {
    if (isPlaying) {
      changePlayer();
      reStart = true;
    }
  }

  void endChange(double value) {
    if (reStart) {
      changePlayer();
      reStart = false;
    }
  }

  void changePlayer() {
    isPlaying = !isPlaying;
    reStart = false;
    if (isPlaying) {
      controller.forward(from: actualNumber / entre.actions[actionNumber].time);
    } else {
      controller.stop();
      actualNumber = alpha.value;
    }
    setState(() {});
  }

  void onChangeBar(double value) {
    actualNumber = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Entrainement: ${entre.name}"),
          ),
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      Text(
                        '${entre.actions[actionNumber].name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text(
                          actionNumber < entre.actions.length-1
                              ? '-> ${entre.actions[actionNumber + 1].name}'
                              : 'Fin',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 110,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container()),
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              onPressed: prev,
                              splashRadius: 20,
                            ),
                            IconButton(
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow),
                              onPressed: changePlayer,
                              splashRadius: 30,
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              onPressed: skip,
                              splashRadius: 20,
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Text(
                                '${controller.isAnimating ? alpha.value.round() : actualNumber.round()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                min: 0,
                                max: entre.actions[actionNumber].time
                                    .roundToDouble(),
                                value: controller.isAnimating
                                    ? alpha.value
                                    : actualNumber,
                                onChangeStart: startChange,
                                onChangeEnd: endChange,
                                onChanged: onChangeBar,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                '${entre.actions[actionNumber].time.round()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
        onWillPop: disposeTimer);
  }

  Future<bool> disposeTimer() {
    controller.dispose();
    return Future<bool>.value(true);
  }
}
