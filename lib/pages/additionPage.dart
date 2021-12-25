import 'package:flutter/material.dart';
import 'package:minecraft_gallery/models/showBlock.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

class AdditionPage extends StatefulWidget {
  @override
  _AdditionPageState createState() => _AdditionPageState();
}

class _AdditionPageState extends State<AdditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.MODE ? Colors.grey[800] : Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: globals.MODE ? Colors.white : Colors.black,
        ),
        title: Text(
          'Adding your new Work',
          style: TextStyle(
            fontFamily: "Pixer",
            color: globals.MODE ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: globals.MODE ? Colors.black : Colors.white,
        elevation: 1.0,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
