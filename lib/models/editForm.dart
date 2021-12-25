import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minecraft_gallery/models/loading.dart';
import 'package:minecraft_gallery/services/database.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;
import 'package:path/path.dart';

class EditForm extends StatefulWidget {
  final String imagePath;
  final String title;
  final String details;
  final String id;
  EditForm({
    required this.imagePath,
    required this.title,
    required this.details,
    required this.id,
  });
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String? newTitle;
  String? newDetails;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                iconSize: 30,
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.redAccent,
                ),
                onPressed: () => {
                  Navigator.pop(context),
                },
              ),
              !_loading
                  ? Container(
                      width: 200,
                      child: Center(
                        child: Text(
                          'Info editing',
                          style: TextStyle(
                              fontSize: 15,
                              color: globals.MODE ? Colors.white : Colors.black
                              // fontFamily: "Pixer",
                              ),
                        ),
                      ))
                  : Container(
                      width: 40,
                      child: SpinKitRing(
                        color: Colors.grey,
                        size: 30.0,
                      ),
                    ),
              IconButton(
                iconSize: 30,
                icon: Icon(
                  Icons.check_circle_outlined,
                  color: Colors.greenAccent,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loading = !_loading;
                    });
                    await _updateToFirebase();
                    // _loading = !_loading;
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                  color: globals.MODE ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Image.network(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextFormField(
              initialValue: widget.title,
              style:
                  TextStyle(color: globals.MODE ? Colors.white : Colors.black),
              decoration: globals.MODE
                  ? globals.titleInputDecorationDark
                  : globals.titleInputDecoration,
              validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              onChanged: (val) => setState(() => newTitle = val),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              initialValue: widget.details,
              style:
                  TextStyle(color: globals.MODE ? Colors.white : Colors.black),
              decoration: globals.MODE
                  ? globals.detailsInputDecorationDark
                  : globals.detailsInputDecoration,
              validator: (val) =>
                  val!.isEmpty ? 'Please fill the details' : null,
              onChanged: (val) => setState(() => newDetails = val),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future _updateToFirebase() async {
    Database().updateImage(
        widget.id, newTitle ?? widget.title, newDetails ?? widget.details);
  }
}
