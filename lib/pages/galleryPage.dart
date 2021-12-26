import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minecraft_gallery/models/ImageDetails.dart';
import 'package:minecraft_gallery/models/showBlock.dart';
import 'package:minecraft_gallery/pages/DetailsPage.dart';
import 'package:minecraft_gallery/pages/albumList.dart';
import 'package:minecraft_gallery/services/database.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Stream<QuerySnapshot> images =
      FirebaseFirestore.instance.collection('images').snapshots();
  void initialList() {
    images = FirebaseFirestore.instance.collection('images').snapshots();
  }

  void searchingList() {
    setState(() {
      images = FirebaseFirestore.instance
          .collection('images')
          .where('title', isGreaterThanOrEqualTo: globals.aim)
          .where('title', isLessThan: globals.aim + 'z')
          .snapshots();
    });
    print(images);
  }

  List _selectedList = [];
  @override
  Widget build(BuildContext context) {
    if (!globals.EDIT) {
      if (globals.aim.isNotEmpty) {
        searchingList();
      } else {
        initialList();
      }
    }

    return Scaffold(
      backgroundColor: globals.MODE ? Colors.grey[800] : Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: images,
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
                  return RawMaterialButton(
                    onPressed: () {
                      if (globals.EDIT) {
                        setState(() {
                          if (_isSelected(data.docs[index].reference.id)) {
                            _selectedList.remove(data.docs[index].reference.id);
                          } else {
                            _selectedList.add(data.docs[index].reference.id);
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              id: data.docs[index].reference.id,
                              imagePath: data.docs[index]['imagePath'],
                              title: data.docs[index]['title'],
                              time:
                                  data.docs[index]['time'].toDate().toString(),
                              location: data.docs[index]['address'],
                              details: data.docs[index]['details'],
                              index: index,
                            ),
                          ),
                        );
                      }
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
                    child: Hero(
                      tag: 'logo$index',
                      child: Container(
                        decoration: BoxDecoration(
                          border: _isSelected(data.docs[index].reference.id)
                              ? Border.all(
                                  color: globals.MODE
                                      ? Colors.pinkAccent
                                      : Colors.greenAccent,
                                  width: 5)
                              : null,
                          color: globals.MODE
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(data.docs[index]['imagePath']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
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
                          Icons.move_to_inbox,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          print(_selectedList);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumList(
                                imageId: []..addAll(_selectedList),
                              ),
                            ),
                          );
                          setState(() {
                            globals.EDIT = false;
                            _selectedList.clear();
                          });
                        },
                      ),
                    )),
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
          await Database().removeImage(id);
          await Database().clearImageFromAlbum2(id);
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
