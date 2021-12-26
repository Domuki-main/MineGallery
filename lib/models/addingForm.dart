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

class AddingForm extends StatefulWidget {
  @override
  _AddingFormState createState() => _AddingFormState();
}

class _AddingFormState extends State<AddingForm> {
  final _formKey = GlobalKey<FormState>();

  UploadTask? task;
  XFile? _image;
  File? _img;
  dynamic _pickImageError;

  late File uploadImg;
  late String title;
  late String time;
  late String location;
  late String details;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  _imgFromCamera() async {
    try {
      final _pick = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      setState(() {
        _image = _pick!;
        _img = File(_image!.path);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _imgFromGallery() async {
    try {
      final _pick = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      setState(() {
        _image = _pick!;
        _img = File(_image!.path);
      });
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
      print("error");
      print(e);
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

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
                        child: _img == null
                            ? Text(
                                'Please Select Your Image',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: globals.MODE
                                        ? Colors.white
                                        : Colors.black
                                    // fontFamily: "Pixer",
                                    ),
                              )
                            : Text(
                                'Fill the info and share your work!',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: globals.MODE
                                        ? Colors.white
                                        : Colors.black
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
                    if (_img == null) return;
                    setState(() {
                      _loading = !_loading;
                    });
                    await _uploadToFirebase();
                    // _loading = !_loading;
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
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                    color: globals.MODE ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: _image != null
                    ? Image.file(
                        _img!,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.camera_alt,
                        color:
                            globals.MODE ? Colors.grey[200] : Colors.grey[800],
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
    if (_img == null) return;
    final fileName = basename(_img!.path);
    final destination = 'images/$fileName';
    // print("processing");
    task = Database().uploadFile(destination, _img!);
    // print("end");
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    // print('Download-Link: $urlDownload');
    await _uploadToFireStore(urlDownload);
  }

  Future _uploadToFireStore(String url) async {
    if (_formKey.currentState!.validate()) {
      await Database().addImage(title, details, url);
    } else {}
  }
}
