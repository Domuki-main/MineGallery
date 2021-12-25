library my_prj.globals;

import 'package:flutter/material.dart';

// const Color L_APPBAR = Colors.white;
// const Color L_FONT = Colors.black;
// const Color L_ICON = Colors.black;
bool MODE = false;
bool EDIT = false;
String aim = "";

const titleInputDecoration = InputDecoration(
  hintText: 'Title of your work',
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
      width: 2.0,
    ),
  ),
);

const detailsInputDecoration = InputDecoration(
  hintText: 'Details',
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
      width: 2.0,
    ),
  ),
);

const titleInputDecorationDark = InputDecoration(
  hintText: 'Title of your work',
  fillColor: Colors.black,
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
  ),
);

const detailsInputDecorationDark = InputDecoration(
  hintText: 'Details',
  fillColor: Colors.black,
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
  ),
);
