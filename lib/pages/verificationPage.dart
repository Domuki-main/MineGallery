import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:minecraft_gallery/api/local_auth_api.dart';
import 'package:minecraft_gallery/pages/dashboardPage.dart';

class VerificationPage extends StatelessWidget {
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();
          print(isAuthenticated);
          if (isAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.image,
              size: 124.0,
            ),
            Text(
              "Mine Gallery",
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Pixer',
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Touch to Login",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Pixer',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
