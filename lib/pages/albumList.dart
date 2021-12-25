import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minecraft_gallery/pages/albumDetailPage.dart';
import 'package:minecraft_gallery/services/database.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

class AlbumList extends StatefulWidget {
  // const AlbumList({Key? key}) : super(key: key);
  final List imageId;
  AlbumList({required this.imageId});

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  late List imageId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageId = widget.imageId;
    print(imageId);
  }

  final Stream<QuerySnapshot> albums =
      FirebaseFirestore.instance.collection('albums').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Card(
                    color: globals.MODE ? Colors.grey[800] : Colors.grey[100],
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.folder_outlined,
                            size: 60,
                          ),
                          Text(data.docs[index]['title']),
                        ],
                      ),
                      onTap: () async {
                        String albumID = data.docs[index].reference.id;
                        for (String id in imageId) {
                          print(id);
                          await Database()
                              .putInAlbum(albumId: albumID, imageId: id);
                        }
                        Navigator.pushReplacement(
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
}
