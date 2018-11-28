import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:nw/pages/chat_room.dart';
import 'package:nw/models/user.dart';
import 'package:nw/util/req.dart' as io;

class ContactScreen extends StatefulWidget {
  
  final User me;
  ContactScreen(this.me);

  @override
  State<StatefulWidget> createState() {
    return ContactScreenState();
  }
}

class ContactScreenState extends State<ContactScreen> {
  List<Contact> _contacts;
  //static List<Contact> temp;

  @override
  initState() {

    loadContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: _contacts != null
            ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact c = _contacts?.elementAt(index) ?? nullContact();
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ChatRoom(widget.me, chatContact: c) //ChatRoom(c)
                          ));
                    },
                    leading: (c.avatar != null && c.avatar.length > 0)
                        ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                        : CircleAvatar(
                            child: Text(c.displayName.length > 1
                                ? c.displayName?.substring(0, 2)
                                : "")),
                    title: Text(c.displayName ?? ""),
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),//Text("Vazio!"),
      ),
    );
  }

  loadContacts() async {
    var listOfUsers = await io.getUserList();

    var iter = await ContactsService.getContacts();
    var contacts = iter.toList();
    var users = List<Contact>();
    
    // for(var i=0; i<(listOfUsers?.length ?? 0); i++) {         
    for(var i=0; i<(contacts?.length ?? 0); i++) {

      var phones = contacts[i].phones.toList();

      for(var j=0; j<listOfUsers.length; j++) {  
       // print(phones[j].value);
       for(var k=0; k<phones.length; k++) {
          if(listOfUsers[j]["phoneNumber"] == phones[k].value) {
            users.add(contacts[i]);
         // print("contato $i: ${contacts[i]}");
          }
        }
      }
    }

    setState(() {
      if ((users?.length ?? 0) > 0) {
        _contacts = users;
      }
      else {
        _contacts = List()..add(nullContact());
      }
    });
    
    //temp = users;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Contact nullContact() {
    Map map = {
      "displayName": "Teste",
      "identifier" : "empty_list",
    };
    return Contact.fromMap(map);
  }
}
