import 'package:flutter/material.dart';

class HomeImg extends StatelessWidget {
  const HomeImg({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
    padding: EdgeInsets.all(15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
    image: AssetImage("assets/undraw_to_do_list_a49b.png"),
    height: 200.00,
    fit: BoxFit.cover,
  ),
      ],
    ),
  );
  }
}