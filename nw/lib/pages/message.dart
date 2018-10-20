import 'package:flutter/material.dart';

final defaultUserName = "Gabriel Pacheco";

class Msg extends StatelessWidget {
  String txt;
  final AnimationController animationController;
  Msg({this.txt, this.animationController});

  @override
  Widget build(BuildContext context) {
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
              child: CircleAvatar(child: Text(defaultUserName[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(defaultUserName, style: TextStyle(fontWeight: FontWeight.bold)/*Theme.of(context).textTheme.subhead */),
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