import 'dart:async';
import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart' show DateFormat;

class Recorder {
  bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String recorderTxt = '00:00:00';
  String playerTxt = '00:00:00';

  Recorder() {
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
  }


  void startRecorder() async{
    try {
      String path = await flutterSound.startRecorder(null);
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        String txt = DateFormat('mm:ss:SS', 'en_US').format(date);

        // this.setState(() {
          this.recorderTxt = txt.substring(0, 8);
        // });
      });

      // this.setState(() {
        this._isRecording = true;
      // });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder() async{
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }

      // this.setState(() {
        this._isRecording = false;
      // });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void startPlayer() async{
    String path = await flutterSound.startPlayer(null);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
          String txt = DateFormat('mm:ss:SS', 'en_US').format(date);
          // this.setState(() {
            this._isPlaying = true;
            this.playerTxt = txt.substring(0, 8);
          // });
        }
      });
    } catch (err) {
      print('error: $err');
    }
  }

  void stopPlayer() async{
    try {
      String result = await flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }

      // this.setState(() {
        this._isPlaying = false;
      // });
    } catch (err) {
      print('error: $err');
    }
  }

  void pausePlayer() async{
    String result = await flutterSound.pausePlayer();
    print('pausePlayer: $result');
  }

  void resumePlayer() async{
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
  }

  void seekToPlayer(int milliSecs) async{
    int secs = Platform.isIOS ? milliSecs / 1000 : milliSecs;

    String result = await flutterSound.seekToPlayer(secs);
    print('seekToPlayer: $result');
  }
}