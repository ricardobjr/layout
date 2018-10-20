import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:nw/pages/chat_room.dart';
import 'package:nw/util/req.dart' as io;

class ContactScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactScreenState();
  }
}

class ContactScreenState extends State<ContactScreen> {
  // var _isLoading = true;
  List<Contact> _contacts;

  // ContactScreenState() {
  //   initTempList();
  // }

  @override
  initState() {

    loadContacts();
    super.initState();
    //  initPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: _contacts != null /* || (_contacts.elementAt(0).identifier != "empty_list_of_contacts") */
            ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact c = _contacts?.elementAt(index) ?? nullContact();
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ChatRoom() //ChatRoom(c)
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
    var listaOfUsers = await io.getUserList();

    var iter = await ContactsService.getContacts();
    var contacts = iter.toList();
    var users = List<Contact>();
    
    for(var i=0; i<(listaOfUsers?.length ?? 0); i++) {

      var phones = contacts[i].phones.toList();

      for(var j=0; j<(phones?.length ?? 0); j++) {
        if(listaOfUsers[i]["phoneNumber"] == phones[j]) {
          users?.add(contacts[i]);
        }
      }
    }

    setState(() {
      if ((users?.length ?? 0) > 0) _contacts = users;
      else _contacts = List()..add(nullContact());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Contact nullContact() {
    Map map = {
      "displayName": "Null",
      "identifier" : "empty_list",
    };
    return Contact.fromMap(map);
  }
}
