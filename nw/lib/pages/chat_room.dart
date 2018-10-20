import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nw/pages/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:nw/models/chat_model.dart';
import 'package:translator/translator.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

/// CHAT WINDOW/ CHAT WITH SOMEONES WINDOW           (v1)
/// 
/// 
                      /**
                       * 
                       * TODO:
                       * 
                       *    create in database field "phoneNumber".
                       *    send 'phoneNumber' to db for purposes ->  1) check if contact is registered, that is, 
                       * verify if contact (friend) is also using the app.
                       * 
                       * 
                       *  regex for phone numbers:     '(/\d+/g)' ou r'(d+/g)' ou r'(+(d+/s))' -> ex: +55 ou +387
                       *  get country code using country code list.
                       * 
                       *  OR 
                       * 
                       *  @prefered
                       *  get language code using Locale class (setup flutter_localizations before that).
                       *  
                       *  fill FRIENDS tab with contacts that have installed the app
                       *    (verifying the phoneNumber in database)
                       * 
                       */

class ChatRoom extends StatefulWidget {
  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  WebSocketChannel channel;

  @override
    void initState() {
      super.initState();
      try {
        // channel = IOWebSocketChannel.connect('ws://192.168.0.15:8888/connect');   //change to local IP
        channel = IOWebSocketChannel.connect('ws://ts-websocket-server.herokuapp.com/connect');
        print("Conectado a ${dummyData[0].name}");

        // listen for data coming from server -> then display text in chat room
        channel.stream.listen((data) => setState(() => displayMsg(data as String)/* _submitMsg(data as String) */));
      }
      catch(e) {
        print("Erro: Não foi possivel conectar ao WS");
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // avatar
        title: Text("${dummyData[0].name}"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: Column(children: <Widget>[
        // Column(
        //  children: lista.map((d) => Text('Eu: $d')).toList(),
        // ),
        Flexible(
            child: ListView.builder(
          itemBuilder: (_, int index) => _messages[index],//_messages[index],
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

  Widget _buildComposer() { // 'typing and send' row
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
                  onSubmitted: _submitMsg,
                  decoration: InputDecoration.collapsed(
                      hintText: "Digite aqui para enviar a mensagem"),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Enviar"),
                          onPressed: _isWriting
                              ? () => _sendDataToServer()//_submitMsg(_textController.text)
                              : null)
                      : IconButton(
                          icon: Icon(Icons.send,
                              color: _isWriting ? Colors.blue : null),
                          onPressed: _isWriting
                              ? () => _sendDataToServer()// _submitMsg(_textController.text);
                              : null))
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void _submitMsg(String txt) async {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });

    Msg msg = new Msg(
      txt: await translateTxt(txt, to: 'en'),
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)),
    );

    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  void _sendDataToServer() {
    if(_textController.text.isNotEmpty) {
      channel.sink.add(_textController.text);
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

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    channel.sink.close();
    super.dispose();
  }
}
