import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minecraft_gallery/models/ImageDetails.dart';
import 'package:minecraft_gallery/services/database.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

import 'DetailsPage.dart';

class AlbumDetailPage extends StatefulWidget {
  // const AlbumDetailPage({Key? key}) : super(key: key);
  final String albumId;
  final String title;
  final String details;
  AlbumDetailPage({
    required this.albumId,
    required this.title,
    required this.details,
  });

  @override
  _AlbumDetailPageState createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  late CollectionReference albums_images;
  List ids = [];
  List imgList = [];
  List _selectedList = []; //id of the image(collection)

  CollectionReference images = FirebaseFirestore.instance.collection('images');

  void initState() {
    getImageId(widget.albumId);
  }

  void getImageId(String albumId) async {
    albums_images = FirebaseFirestore.instance.collection('albums_images');
    await albums_images
        .where('albumId', isEqualTo: albumId)
        .get()
        .then((val) => {
              val.docs.forEach((doc) {
                ids.add(doc.get('imageId'));
              }),
            });

    getImgList();
  }

  Future<void> getImgList() async {
    List _getimgList = [];
    for (var id in ids) {
      await images.doc(id).get().then(
            (val) => {
              _getimgList.add(
                ImageDetails(
                  id: id,
                  imagePath: val.get('imagePath'),
                  location: val.get('address'),
                  time: val.get('time').toDate().toString(),
                  title: val.get('title'),
                  details: val.get('details'),
                ),
              ),
            },
          );
    }
    setState(() {
      imgList = _getimgList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.MODE ? Colors.grey[800] : Colors.grey[200],
      appBar: AppBar(
        backgroundColor: globals.MODE ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: globals.MODE ? Colors.white : Colors.black,
        ),
        elevation: 1.0,
        title: !globals.EDIT
            ? Text(
                widget.title,
                style: TextStyle(
                  color: globals.MODE ? Colors.white : Colors.black,
                ),
              )
            : Text(
                'You have selected ${_selectedList.length} items',
                style: TextStyle(
                  color: globals.MODE ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: globals.EDIT
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        globals.EDIT = false;
                        _selectedList.clear();
                      });
                    },
                    icon: Icon(Icons.close),
                  )
                : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: imgList.length,
          itemBuilder: (context, index) {
            return RawMaterialButton(
              onPressed: () {
                if (globals.EDIT) {
                  setState(() {
                    if (_isSelected(imgList[index].id)) {
                      _selectedList.remove(imgList[index].id);
                    } else {
                      _selectedList.add(imgList[index].id);
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        id: imgList[index].id,
                        imagePath: imgList[index].imagePath,
                        title: imgList[index].title,
                        time: imgList[index].time,
                        location: imgList[index].location,
                        details: imgList[index].details,
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
                    _selectedList.add(imgList[index].id);
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
                    border: _isSelected(imgList[index].id)
                        ? Border.all(
                            color: globals.MODE
                                ? Colors.pinkAccent
                                : Colors.greenAccent,
                            width: 5)
                        : null,
                    color: globals.MODE ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(imgList[index].imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: globals.EDIT
          ? FloatingActionButton(
              backgroundColor:
                  globals.MODE ? Colors.grey[100] : Colors.grey[900],
              child: new IconTheme(
                data: new IconThemeData(
                    color: globals.MODE ? Colors.black : Colors.white),
                child: new Icon(Icons.delete_outline),
              ),
              onPressed: () async {
                for (var id in _selectedList) {
                  await Database().moveOutAlbum(id: id);
                }
                setState(() {
                  globals.EDIT = false;
                  _selectedList.clear();
                  ids.clear();
                  imgList.clear();
                });
                getImageId(widget.albumId);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => super.widget));
              },
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

  _isInAlbum(String id) {
    if (ids.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
}
