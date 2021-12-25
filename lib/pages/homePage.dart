import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minecraft_gallery/models/showBlock.dart';
import 'package:minecraft_gallery/themes/globals.dart' as globals;

import 'DetailsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> images = FirebaseFirestore.instance
      .collection("images")
      .orderBy("time", descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.MODE ? Colors.grey[800] : Colors.grey[200],
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: images,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitRing(
                    color: Colors.grey,
                    size: 50.0,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Icon(
                    Icons.wifi_off,
                    size: 50,
                  ),
                );
              } else {
                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size > 4 ? 4 : data.size,
                  itemBuilder: (context, index) {
                    return RawMaterialButton(
                      onPressed: () {
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
                      },
                      child: ShowBlock(
                        url: data.docs[index]['imagePath'],
                        title: data.docs[index]['title'],
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
