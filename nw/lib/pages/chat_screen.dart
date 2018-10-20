import 'package:flutter/material.dart';
import 'package:nw/models/chat_model.dart';
import 'package:nw/pages/chat_room.dart';
import 'package:nw/models/user.dart';
import 'package:nw/store/storage.dart';
import 'package:nw/util/req.dart' as db;

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  //  String _username;// = "novo_user_teste";
  //  String _password;// = "1234";
  // String _nativeLanguage;

  Storage store = Storage();
  User me;

  @override
  void initState() {

    //initUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, i) => new Column(children: <Widget>[
            new Divider(height: 10.0),
            new ListTile(
                leading: new CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage: new NetworkImage(dummyData[i].avatarUrl),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      dummyData[i].name,
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      dummyData[i].time,
                      style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    dummyData[i].message,
                    style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(),
                    ))),
          ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  //void getList(List l) async => l = await db.getUserList(_username, _password);

  // Future<User> getUser() async {
  //   var userData = await db.getMe();
  //   int id = userData["id"];
  //   String username = userData["username"];
  //   String nativelang = userData["nativeLanguage"];

  //   return User(id: id, username: username, nativelang: nativelang);
  // }

  // void getCredentials() async {
  //   var credentials = await store.readData();
  //   setState(() {
  //     _username = credentials.split('~')[0];
  //     _password = credentials.split('~')[1];
  //   });
  // }

  // Future<bool> get isRegistered async {
  //   try {
  //     var str = "";
  //     var str2 = await store.readData();

  //     str += str2;
  //     if(str.length > 0 || str.contains('username')) {
  //       return true;
  //     }
  //     else return false;

  //   } 
  //   catch(e) {
  //     return false;
  //   }
  // }

  // void initUser() async {
  //   if((await isRegistered) == true) {
  //     //print("If statement");

  //     getCredentials();
  //     me = await getUser();

  //     print("Usuário ${me.username} with ID: ${me.id} speaks ${me.nativelang}");
  //   }
  //   else {
  //     //print("Else statement");
      
  //     Locale myLocale = Localizations.localeOf(context);   //TODO: FIX THIS

  //     var lastId = await db.getLastIdFromDatabase();
  //     _username/* var autoUser */ = "_username_${lastId+1}";
  //     _password/* var autoPassw */ = "_password_${lastId+1}";

  //     db.createThisUser(_username/* autoUser */, _password/* autoPassw */, myLocale.languageCode);

  //     store.writeData(_username/* autoUser */, _password/* autoPassw */);
  //     getCredentials();
  //     me = await getUser();
      
  //     print("Novo user cadastrado!!!!");
  //   }
  // }
}
