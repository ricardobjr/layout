import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart' show DateFormat;

import 'package:flutter/material.dart';
import 'package:nw/pages/message.dart';
import 'package:flutter/cupertino.dart';
// import 'package:nw/models/chat_model.dart';
import 'package:translator/translator.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'package:nw/models/user.dart';
// import 'package:nw/chat_home.dart';
// import 'package:nw/audio/speech_recognizer.dart';
import 'package:nw/store/storage.dart';
import 'package:nw/pages/speech_rec.dart';
// import 'package:nw/audio/recorder.dart';
// import 'package:nw/audio/recorder_2.dart';

import 'package:nw/util/permissions.dart' as allow;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';


/// CHAT WINDOW/ CHAT WITH SOMEONES WINDOW           (v1)
///
///

class ChatRoom extends StatefulWidget {
  @override
  ChatRoomState createState() => ChatRoomState();

  ChatRoom(this.me, {this.chatContact});
  final Contact chatContact;
  final User me;
}

class ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;
  // bool _isRecording = false;

  WebSocketChannel channel;

  Storage store;
  // Recorder audioRec;
   bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';

  Directory appDocDir;

  @override
  void initState() {
    // allow.initPermissions();
    //allow.requestPermission(Permission.WriteExternalStorage);
    store = Storage();
    // audioRec = Recorder();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);

    super.initState();
    try {
      channel = IOWebSocketChannel.connect(
          'ws://192.168.0.15:8888/connect'); //change to local IP
      // channel = IOWebSocketChannel.connect('ws://ts-websocket-server.herokuapp.com/connect');
      print("Using ${channel.protocol} from 192.168.0.15/connect");
      print("Conectado a ${widget.chatContact?.displayName ?? 'Teste'}");

      // listen for data coming from server -> then display text in chat room
      channel.stream.listen((data) => setState(() {
            var msg = utf8.decode(data);
            displayMsg(msg /* data as String */);
          } /* _submitMsg(data as String) */));
    } catch (e) {
      print("Erro: Não foi possivel conectar ao servidor WS\n$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // avatar
        // title: Text("${dummyData[0].name}"),
        title: Text("${widget.chatContact?.displayName ?? 'Teste'}"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: Column(children: <Widget>[
        // Column(
        //  children: lista.map((d) => Text('Eu: $d')).toList(),
        // ),
        Flexible(
            child: ListView.builder(
          itemBuilder: (_, int index) => _messages[index], //_messages[index],
          itemCount: _messages.length,
          reverse: true,
          padding: const EdgeInsets.all(6.0),
        )),
        Divider(height: 1.0),
        Container(
          child: _buildComposer(),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
        ),
      ]),
    );
  }

  Widget _buildComposer() {
    // 'typing and send' row
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: null, //_submitMsg,
                  decoration: InputDecoration.collapsed(
                      hintText: "Digite aqui para enviar a mensagem"),
                  autofocus: true,
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Enviar"),
                          onPressed: _isWriting
                              ? () =>
                                  _sendDataToServer() //_submitMsg(_textController.text)
                              : null)
                      : IconButton(
                          icon: Icon(Icons.send,
                              color: _isWriting ? Colors.blue : null),
                          onPressed: _isWriting
                              ? () =>
                                  _sendDataToServer() // _submitMsg(_textController.text);
                              : null)),

              // excluir se der erro
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Gravar"),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpeechRec())))
                      : IconButton(
                          icon: Icon(Icons.mic,
                              color: this._isRecording ? Colors.green : Colors.blue),
                          onPressed: () {
                            //.getPermissions();
                            if(!this._isRecording) {
                              this._isRecording = true;
                              return this.startRecorder();
                              // audioRec.stopRecorder();
                            }
                            return this.stopRecorder();
                          }
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void _submitMsg(String txt, [bool isMine]) async {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });

    Msg msg = new Msg(
      txt: await translateTxt(txt, to: 'en'),
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)),
      name: widget.me.displayName, //widget.chatContact?.displayName ?? null,
    );

    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();

    print("Mensagem vinda do servidor: ${_messages.elementAt(0).txt}");
  }

  void _sendDataToServer() {
    // var msgMap = {"text": _textController.text};
    // if(_textController.text.isNotEmpty) {
    //   channel.sink.add(utf8.encode(json.encode(msgMap)));
    // }
    if (_textController.text.isNotEmpty) {
      channel.sink.add(utf8.encode(_textController.text));
      print("Dados enviados ao servidor!!");
    }
  }

  Future<String> translateTxt(String text,
      {String from = 'auto', String to = 'en'}) async {
    return await GoogleTranslator().translate(text, from: from, to: to);
  }

  /// This method only exists to avoid Flutter's setState() async warning.
  void displayMsg(String txt) {
    _submitMsg(txt);
  }

  void startRecorder() async{
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      setState(() {
        appDocDir = dir;
      });
      String path = await flutterSound.startRecorder(dir.path);
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        String txt = DateFormat('mm:ss:SS', 'en_US').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });

      this.setState(() {
        this._isRecording = true;
      });
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

      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void startPlayer() async{
    String path = await flutterSound.startPlayer(appDocDir.path);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
          String txt = DateFormat('mm:ss:SS', 'en_US').format(date);
          this.setState(() {
            this._isPlaying = true;
            this._playerTxt = txt.substring(0, 8);
          });
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

      this.setState(() {
        this._isPlaying = false;
      });
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

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    channel.sink.close();

    // excluir se der erro
    store.readChatList().then((str) {
      if (str.contains("${widget.chatContact.displayName}")) {
      } else {
        if (_messages.isNotEmpty) {
          store.writeChatTileList('${widget.chatContact.displayName}');
        }
      }
    });

    super.dispose();
  }
}
