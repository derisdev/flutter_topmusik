import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:topmusik/ui/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
)); 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTS Populer',
      theme: ThemeData(
      ),
      home: HomePage(),
    );
  }
}
