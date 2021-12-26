import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minecraft_gallery/pages/albumDetailPage.dart';
import 'package:minecraft_gallery/services/database.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final Stream<QuerySnapshot> albums =
      FirebaseFirestore.instance.collection('albums').snapshots();

  List _selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globals.EDIT
          ? AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: Text(
                'You selected ${_selectedList.length} items',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              backgroundColor:
                  globals.MODE ? Colors.pinkAccent : Colors.greenAccent,
              elevation: 1.0,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() {
                          showAlertDialog(context);
                        }),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() {
                          globals.EDIT = false;
                          _selectedList.clear();
                        }),
                      ),
                    )),
              ],
            )
          : null,
      backgroundColor: globals.MODE ? Colors.grey[800] : Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: albums,
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitRing(
                  color: Colors.grey,
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Something went ');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Icon(
                  Icons.wifi_off,
                  size: 50,
                ),
              );
            } else {
              final data = snapshot.requireData;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Card(
                    color: globals.MODE ? Colors.grey[800] : Colors.grey[100],
                    child: Container(
                      decoration: BoxDecoration(
                        border: _isSelected(data.docs[index].reference.id)
                            ? Border.all(
                                color: globals.MODE
                                    ? Colors.pinkAccent
                                    : Colors.greenAccent,
                                width: 5)
                            : null,
                        color:
                            globals.MODE ? Colors.grey[600] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(
                              Icons.folder_outlined,
                              color: globals.MODE
                                  ? Colors.grey[100]
                                  : Colors.grey[800],
                              size: 40,
                            ),
                            Text(
                              data.docs[index]['title'],
                              style: TextStyle(
                                color: globals.MODE
                                    ? Colors.grey[100]
                                    : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (globals.EDIT) {
                            setState(() {
                              if (_isSelected(data.docs[index].reference.id)) {
                                _selectedList
                                    .remove(data.docs[index].reference.id);
                              } else {
                                _selectedList
                                    .add(data.docs[index].reference.id);
                              }
                            });
                          } else
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlbumDetailPage(
                                  albumId: data.docs[index].reference.id,
                                  title: data.docs[index]['title'],
                                  details: data.docs[index]['details'],
                                ),
                              ),
                            );
                        },
                        onLongPress: () {
                          if (!globals.EDIT) {
                            setState(() {
                              globals.EDIT = true;
                              _selectedList.add(data.docs[index].reference.id);
                            });
                          } else {
                            setState(() {
                              _selectedList.clear();
                              print("clean");
                              print(_selectedList.length);
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  _isSelected(String id) {
    if (_selectedList.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  //popup to confirming if it have to be deleted
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Delete"),
      onPressed: () async {
        //delete the list of document
        for (String id in _selectedList) {
          await Database().clearImageFromAlbum(id);
        }
        for (String id in _selectedList) {
          await Database().deleteAlbum(id);
        }
        Navigator.pop(context);
        setState(() {
          globals.EDIT = false;
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Would you like to continue Deleting the images?"),
      actions: [
        cancelButton,
        continueButton,
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
