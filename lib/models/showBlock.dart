import 'package:flutter/material.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

class ShowBlock extends StatelessWidget {
  final String url;
  final String title;
  ShowBlock({
    required this.url,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 6, 15, 6),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: globals.MODE ? Colors.grey[200] : Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
            ),
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: "Pixer",
                ),
              ),
            )),
      ),
    );
  }
}
