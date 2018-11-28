import 'package:flutter/material.dart';
import 'package:nw/pages/chat_screen.dart';
import 'package:nw/pages/contacts_screen.dart';
import 'package:nw/models/user.dart';
import 'package:nw/store/storage.dart';
import 'package:nw/util/req.dart' as db;
import 'dart:math' show Random;
import 'package:nw/util/permissions.dart' as allow;

class ChatHome extends StatefulWidget {

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _textController;

  Storage store;// = Storage();
  User me;

  @override
  void initState() {

    store = Storage();

    // allow.initPermissions();
    allow.getPermissions();
    initUser();
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 2);
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Chat Translate System"),
        elevation: 0.7,
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            new Tab(
              text: "CHATS",              
            ),
            new Tab(
              text: "FRIENDS",      // contatos que utiizam o app  
            ),
          ],
        ),
        actions: <Widget>[
          new Icon(Icons.search),
          new Icon(Icons.more_vert),
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          )
        ],
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new ChatScreen(me),         
          new ContactScreen(me),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => print("Nothing"), //TODO: implement this
      ),
    );
  }


  Future<User> getUser() async {
    var userData = await db.getMe();
    int id = userData["id"];
    String username = userData["username"];
    String nativelang = userData["nativeLanguage"];
    String phoneNumber = userData["phoneNumber"];
    String displayName = userData["displayName"];

    return User(id: id, username: username, nativelang: nativelang,  phoneNumber: phoneNumber, displayName: displayName);
  }

  Future<bool> get isRegistered async {
    try {
      // var str = "";
      var str = await store.readData();

      //str += str2;
      if(/* str.length > 0 */str.contains("error") && str.isNotEmpty) {
        return false;
      }
      else return true;

    } 
    catch(e) {
      return false;
    }
  }

  void initUser() async {
    if(await isRegistered) {
      //print("If statement");

      //getCredentials();
     
      me = await getUser();

      print("Usuário ${me.username} with ID: ${me.id} speaks ${me.nativelang}");
    }
    else {
      //print("Else statement");

      var phoneNumber = await _askPhoneNumber();
      var displayName = await _askDisplayName();
      
      Locale myLocale = Localizations.localeOf(context);   //TODO: FIX THIS

      //var lastId = await db.getLastIdFromDatabase();
      var idi = Random().nextInt(999);
      var username = "_username_$idi";
      var password = "_password_$idi";

      //number format:    +55 12   9XXXX-XXXX
      //                   cc  ddd   

      db.createThisUser(username, password, myLocale.languageCode, phoneNumber, displayName);

      store.writeData(username, password);
      
      me = await getUser();

      print("Novo user cadastrado!!!!");
    }
  }


Future<String> _askPhoneNumber() async {
    return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Type this phone number'),
        children: <Widget>[
          // SimpleDialogOption(
          //   onPressed: () { Navigator.pop(context, Department.treasury); },
          //   child: const Text('Treasury department'),
          // ),
          TextField(
            controller: _textController,
            autofocus: true,
            keyboardType: TextInputType.phone,
            scrollPadding: const EdgeInsets.all(8.0),
          ),
          IconButton(
            icon: Icon(Icons.check),
            // onPressed: () => Navigator.of(context, rootNavigator: true).pop(_textController.text)
            onPressed: () => Navigator.pop(context, _textController.text),
          ),
        ],
      );
    }
  );
}

Future<String> _askDisplayName() async {
    return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Type your display name'),
        children: <Widget>[
          // SimpleDialogOption(
          //   onPressed: () { Navigator.pop(context, Department.treasury); },
          //   child: const Text('Treasury department'),
          // ),
          TextField(
            controller: _textController,
            autofocus: true,
            keyboardType: TextInputType.text,
            scrollPadding: const EdgeInsets.all(8.0),
          ),
          IconButton(
            icon: Icon(Icons.check),
            // onPressed: () => Navigator.of(context, rootNavigator: true).pop(_textController.text)
            onPressed: () => Navigator.pop(context, _textController.text),
          ),
        ],
      );
    }
  );
}

  @override
  void dispose() {
    super.dispose();
  }
}
