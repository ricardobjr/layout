import 'package:flutter/material.dart';

const defaultUserName = "John";

class Msg extends StatelessWidget {
  String txt, name;
 // bool isMine;
  final AnimationController animationController;
  Msg({this.txt, this.animationController, this.name,/*  this.isMine = false */});

  @override
  Widget build(BuildContext context) {
    if(name == null) name = defaultUserName;
    return SizeTransition(sizeFactor: CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut
    ),
    axisAlignment:  0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(child: Text(name[0] ?? "G")),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)/*Theme.of(context).textTheme.subhead */),
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: Text(txt, style: TextStyle(color: Colors.grey[800])),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}