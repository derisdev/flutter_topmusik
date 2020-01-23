import 'package:flutter/material.dart';

class PageViewPlayer extends StatefulWidget {
  final String lirik;
  PageViewPlayer({Key key, @required this.lirik}) : super(key:key);
  @override
  _PageViewPlayerState createState() => _PageViewPlayerState();
}

class _PageViewPlayerState extends State<PageViewPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 40),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Text(
          widget.lirik,
          style: new TextStyle(
            fontSize: 16.0,
            height: 3,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
