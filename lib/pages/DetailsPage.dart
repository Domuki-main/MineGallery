import 'package:flutter/material.dart';
import 'package:minecraft_gallery/models/editForm.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

class DetailsPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String time;
  final String location;
  final String details;
  final String id;
  final int index;
  DetailsPage({
    required this.imagePath,
    required this.title,
    required this.time,
    required this.location,
    required this.details,
    required this.index,
    required this.id,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  void _showEditPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          color: globals.MODE ? Colors.grey[900] : Colors.grey[100],
          child: EditForm(
            id: widget.id,
            imagePath: widget.imagePath,
            title: widget.title,
            details: widget.details,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.MODE ? Colors.black : Colors.white,
        elevation: 1.0,
        iconTheme: IconThemeData(
          color: globals.MODE ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: globals.MODE ? Colors.grey[800] : Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              child: Hero(
                tag: 'logo${widget.index}',
                child: Image.network(
                  widget.imagePath,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              margin: new EdgeInsets.only(bottom: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: globals.MODE ? Colors.white : Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Pixer",
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: globals.MODE ? Colors.white : Colors.black,
                              size: 20,
                            ),
                            Text(
                              widget.location,
                              style: TextStyle(
                                color:
                                    globals.MODE ? Colors.white : Colors.black,
                                fontFamily: "Pixer",
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(
                                color:
                                    globals.MODE ? Colors.white : Colors.black,
                                fontFamily: "Pixer",
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.details,
                          style: TextStyle(
                            color: globals.MODE ? Colors.white : Colors.black,
                            fontFamily: "Pixer",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: globals.MODE ? Colors.grey[100] : Colors.grey[900],
        child: new IconTheme(
          data: new IconThemeData(
              color: globals.MODE ? Colors.black : Colors.white),
          child: new Icon(Icons.edit),
        ),
        onPressed: () => {
          _showEditPanel(),
        },
      ),
    );
  }
}
