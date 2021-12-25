import 'package:flutter/material.dart';
import 'package:minecraft_gallery/pages/dashboardPage.dart';
import 'package:minecraft_gallery/pages/verificationPage.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

class SettingPage extends StatefulWidget {
  final Function refreshPages;
  const SettingPage({Key? key, required this.refreshPages}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.MODE ? Colors.grey[800] : Colors.grey[200],
      body: Container(
        child: ListView(
          children: [
            Card(
              color: globals.MODE ? Colors.grey[700] : Colors.white,
              child: SwitchListTile(
                value: globals.MODE,
                activeColor: Colors.pinkAccent,
                title: Text(
                  "Dark Mode",
                  style: TextStyle(
                    color: globals.MODE ? Colors.white : Colors.black,
                  ),
                ),
                onChanged: (value) => setState(() {
                  globals.MODE = value;
                  widget.refreshPages();
                }),
              ),
            ),
            Card(
              color: globals.MODE ? Colors.grey[700] : Colors.white,
              child: ListTile(
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: globals.MODE ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  "Exit current account",
                  style: TextStyle(
                    color: globals.MODE ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () => setState(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationPage()),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
