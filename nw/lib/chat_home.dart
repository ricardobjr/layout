import 'package:flutter/material.dart';
import 'package:nw/pages/chat_screen.dart';
import 'package:nw/pages/contacts_screen.dart';
import 'package:nw/models/user.dart';
import 'package:nw/store/storage.dart';
import 'package:nw/util/req.dart' as db;
import 'package:nw/util/permissions.dart' as allow;

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  //String _username;
  //String _password;

  Storage store = Storage();

  User me;

  @override
  void initState() {
    // TODO: implement initState
    initUser();
    allow.initPermissions();
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 2);
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
          new ChatScreen(),         
          new ContactScreen(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: new Icon(
          //Icons.message,
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

    return User(id: id, username: username, nativelang: nativelang);
  }

  // void getCredentials() async {
  //   var credentials = await store.readData();
  //   setState(() {
  //     _username = credentials.split('~')[0];
  //     _password = credentials.split('~')[1];
  //   });
  // }

  Future<bool> get isRegistered async {
    try {
      var str = "";
      var str2 = await store.readData();

      str += str2;
      if(str.length > 0 || str.contains('username')) {
        return true;
      }
      else return false;

    } 
    catch(e) {
      return false;
    }
  }

  void initUser() async {
    if((await isRegistered) == true) {
      //print("If statement");

      //getCredentials();
      me = await getUser();

      print("Usuário ${me.username} with ID: ${me.id} speaks ${me.nativelang}");
    }
    else {
      //print("Else statement");
      
      Locale myLocale = Localizations.localeOf(context);   //TODO: FIX THIS

      var lastId = await db.getLastIdFromDatabase();
      var username/* var autoUser */ = "_username_${lastId+1}";
      var password/* var autoPassw */ = "_password_${lastId+1}";

      db.createThisUser(username/* autoUser */, password/* autoPassw */, myLocale.languageCode);

      store.writeData(username/* autoUser */, password/* autoPassw */);
      //getCredentials();
      me = await getUser();
      
      print("Novo user cadastrado!!!!");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
