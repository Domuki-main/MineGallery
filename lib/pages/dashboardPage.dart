import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:minecraft_gallery/models/addingForm.dart';
import 'package:minecraft_gallery/models/creatingForm.dart';
import 'package:minecraft_gallery/models/fancyFab.dart';
import 'package:minecraft_gallery/pages/folderPage.dart';
import 'package:minecraft_gallery/pages/galleryPage.dart';
import 'package:minecraft_gallery/pages/homePage.dart';
import 'package:minecraft_gallery/pages/settingPage.dart';

import 'package:minecraft_gallery/themes/globals.dart' as globals;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _showAddingPanel() {
    if (_selectedIndex != 2) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            color: globals.MODE ? Colors.grey[900] : Colors.grey[100],
            child: AddingForm(),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            color: globals.MODE ? Colors.grey[900] : Colors.grey[100],
            child: CreatingForm(),
          );
        },
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _bottomNavPages = []; // 底部导航栏各个可切换页面组

  void initState() {
    super.initState();

    _bottomNavPages
      ..add(HomePage())
      ..add(GalleryPage())
      ..add(FolderPage())
      ..add(SettingPage(
        refreshPages: refreshPages,
      ));
  }

  void refreshPages() {
    setState(() {
      _bottomNavPages.clear();
      _bottomNavPages
        ..add(HomePage())
        ..add(GalleryPage())
        ..add(FolderPage())
        ..add(SettingPage(
          refreshPages: refreshPages,
        ));
    });
  }

  Icon icon = Icon(Icons.search);

  bool _isSearching = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 28,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'What you want to search?',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (aim) {
                          setState(() {
                            globals.aim = aim;
                            refreshPages();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                'Mine Gallery',
                style: TextStyle(
                  fontFamily: "Pixer",
                  color: globals.MODE ? Colors.white : Colors.black,
                ),
              ),
        backgroundColor: globals.MODE ? Colors.black : Colors.white,
        elevation: 1.0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: IconButton(
                  icon: Icon(
                    icon.icon,
                    color: globals.MODE ? Colors.white : Colors.black,
                  ),
                  onPressed: () => setState(() {
                    _onItemTapped(1);
                    _isSearching = !_isSearching;
                    if (_isSearching) {
                      icon = const Icon(Icons.cancel);
                    } else {
                      icon = const Icon(Icons.search);
                    }
                  }),
                ),
              )),
        ],
      ),
      body: _bottomNavPages[_selectedIndex],

      floatingActionButton: FloatingActionButton(
        backgroundColor: globals.MODE ? Colors.grey[100] : Colors.grey[900],
        child: new IconTheme(
          data: new IconThemeData(
              color: globals.MODE ? Colors.black : Colors.white),
          child: new Icon(Icons.add),
        ),
        // onPressed: () => _onItemTapped(1),
        onPressed: () {
          _showAddingPanel();
        },
      ),
      // 设置 floatingActionButton 在底部导航栏中间
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: globals.MODE ? Colors.black : Colors.white,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                color: globals.MODE ? Colors.white : Colors.black,
                size: 30.0,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 1 ? Icons.image : Icons.image_outlined,
                color: globals.MODE ? Colors.white : Colors.black,
                size: 30.0,
              ),
              onPressed: () => {_onItemTapped(1)},
            ),
            SizedBox(), // 增加一些间隔
            IconButton(
              icon: Icon(
                _selectedIndex == 2 ? Icons.folder : Icons.folder_outlined,
                color: globals.MODE ? Colors.white : Colors.black,
                size: 30.0,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 3 ? Icons.settings : Icons.settings_outlined,
                color: globals.MODE ? Colors.white : Colors.black,
                size: 30.0,
              ),
              onPressed: () => {_onItemTapped(3)},
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        // shape: CircularNotchedRectangle(),
      ),
    );
  }
}
