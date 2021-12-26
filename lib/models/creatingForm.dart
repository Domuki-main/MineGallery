import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minecraft_gallery/api/firebaseapi.dart';
import 'package:minecraft_gallery/models/loading.dart';
import 'package:minecraft_gallery/services/database.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;
import 'package:path/path.dart';

class CreatingForm extends StatefulWidget {
  @override
  _CreatingFormState createState() => _CreatingFormState();
}

class _CreatingFormState extends State<CreatingForm> {
  final _formKey = GlobalKey<FormState>();

  UploadTask? task;
  late String _validator;

  late String title;

  late String details;
  bool _loading = false;

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
                  ? Container(width: 200, child: Center())
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
                    bool co = await _uploadToFirebase();
                    _loading = !_loading;
                    // Navigator.pop(context);
                    if (co) {
                      setState(() {
                        showAlertDialog(context);
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                // _showPicker(context);
              },
              child: Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                    color: globals.MODE ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.folder,
                  color: globals.MODE ? Colors.grey[200] : Colors.grey[800],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextFormField(
              // initialValue: "",
              style:
                  TextStyle(color: globals.MODE ? Colors.white : Colors.black),
              decoration: globals.MODE
                  ? globals.titleInputDecorationDark
                  : globals.titleInputDecoration,
              validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              // validator: (value) {},
              onChanged: (val) => setState(() => title = val),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              // initialValue: "",
              style:
                  TextStyle(color: globals.MODE ? Colors.white : Colors.black),
              decoration: globals.MODE
                  ? globals.detailsInputDecorationDark
                  : globals.detailsInputDecoration,
              validator: (val) =>
                  val!.isEmpty ? 'Please fill the details' : null,
              onChanged: (val) => setState(() => details = val),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future _uploadToFirebase() async {
    print(title);
    bool condition = await Database().isAlbumDuplicated(title);
    print(condition);
    if (!condition) {
      await Database().createAlbum(title, details);
    } else {}
    setState(() {});
    return condition;
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("This album has already been created"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
