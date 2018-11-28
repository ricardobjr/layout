import 'package:flutter/material.dart';
import 'package:nw/models/chat_model.dart';
import 'package:nw/pages/chat_room.dart';
import 'package:nw/models/user.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:nw/store/storage.dart';

class ChatScreen extends StatefulWidget {
  final User me;
  ChatScreen(this.me);

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  Storage store = Storage();
  List lista;

  @override
  void initState() {
    initList();
    //print("Lista: ${lista.toList()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
            child: lista != null ? 
            ListView.builder(
              itemCount: /* dummyData.length, */ lista?.length ?? 0,
              itemBuilder: (context, i) => new Column(children: <Widget>[
                  new Divider(height: 10.0),
                  new ListTile(
                leading: new CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage: new NetworkImage(dummyData[0].avatarUrl),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      //dummyData[i].name,
                      lista[i] ?? 'Teste',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      dummyData[0].time,
                      style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    dummyData[0].message,
                    style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(widget.me, chatContact: Contact()..displayName = lista[i],),
                    ))),
          ]),
      ) : Center(child: CircularProgressIndicator())
    ));
  }

  Future<List<String>> namesList() async {
    var data = await store.readChatList();
    var nameList = data.split('~');
    nameList.remove('');

    print("Name list: $nameList");
    return nameList;
  }

  initList() async {
    var x = await namesList();
    setState(() {
      this.lista = x;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
