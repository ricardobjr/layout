import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nw/store/storage.dart';

/// Database [Request]s methods and [File]s management.

Storage store = Storage();

/* get current user as a Map */
Future<Map> getMe() async {
  var str = await store.readData();
  var username = str.split('~')[0];
  var password = str.split('~')[1];

  var clientID = "ts.crud.db";
  var body = "username=$username&password=$password&grant_type=password";
  //print("First body: $body");

  var clientCredentials = Base64Encoder().convert("$clientID:".codeUnits);

  var authToken =
      await http.post("https://chat-crud-ts.herokuapp.com/auth/token",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic $clientCredentials",
          },
          body: body);

  var res = jsonDecode(authToken.body);
  var accessToken = res['access_token'];

  var getMe = await http.get("https://chat-crud-ts.herokuapp.com/me", headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer $accessToken",
  });

  //print("Second body: ${getMe.body}");

  var userMap = jsonDecode(getMe.body);
  return userMap as Map;
}

/* register new user if not already in db  */
void createThisUser(String username, String password, String nativelang) async {
  var clientID = "ts.crud.db";

  var json = {
    "username": "$username",
    "password": "$password",
    "nativeLanguage": "$nativelang"
  };
  var body = jsonEncode(json);

  var clientCredentials = Base64Encoder().convert("$clientID:".codeUnits);

  var register = await http.post("https://chat-crud-ts.herokuapp.com/register",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic $clientCredentials",
      },
      body: body);

  if (register.statusCode == 200)
    print("User created -> status: ${register.statusCode}");
  else
    print("Error when registering user -> status: ${register.statusCode}");
}

Future<List> getUserList() async {
  try {
    var str = await store.readData();
    var username = str.split('~')[0];
    var password = str.split('~')[1];

    var clientID = "ts.crud.db";
    var body = "username=$username&password=$password&grant_type=password";

    var clientCredentials = Base64Encoder().convert("$clientID:".codeUnits);

    var authToken =
        await http.post("https://chat-crud-ts.herokuapp.com/auth/token",
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
              "Authorization": "Basic $clientCredentials",
            },
            body: body);

    var res = jsonDecode(authToken.body);
    var accessToken = res["access_token"];

    var getAllUsers = await http.get("https://chat-crud-ts.herokuapp.com/users",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        });

    var userList = jsonDecode(getAllUsers.body);
    print(getAllUsers.body);
    return userList as List;
  } catch (e) {
    print("\n        Error: $e         \n");
    return null;
  }
}

Future<int> getLastIdFromDatabase() async {
  var list = await getUserList();

  //int counter;
  // list.forEach((u) {
  //   counter++;
  // });
  //for(counter=0; counter<list.length; counter++) {}
  // var lastUser = list[counter];

  var lastUser = list[list.length - 1];
  return (lastUser["id"] as int) + 1;
}
