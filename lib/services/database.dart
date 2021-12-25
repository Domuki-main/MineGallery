import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Database {
  final CollectionReference imageCollection =
      FirebaseFirestore.instance.collection('images');
  final CollectionReference albumCollection =
      FirebaseFirestore.instance.collection('albums');
  final CollectionReference albums_images =
      FirebaseFirestore.instance.collection('albums_images');

  //firestorage methods (management of files)
  // 1. uploading files
  UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  // 2. deleting files
  removeFile(String url) {
    FirebaseStorage.instance.refFromURL(url).delete();
  }

  //firestore methods (management of information)
  //1. uploading doc
  Future addImage(String title, String details, String url) async {
    var coordinate = await getPosition();
    String addr = await getAddress(coordinate);
    return imageCollection
      ..add({
        'imagePath': url,
        'longitude': coordinate.longitude,
        'latitude': coordinate.latitude,
        'address': addr,
        'time': DateTime.now(),
        'title': title,
        'details': details,
      });
  }

  //2. updating doc
  Future<void> updateImage(String id, String title, String details) {
    return imageCollection
        .doc(id)
        .update({
          'title': title,
          'details': details,
        })
        .then((value) => print("Image Updated"))
        .catchError((error) => print("Failed to update image: $error"));
  }

  //3. removing doc
  Future<void> removeImage(String id) async {
    String url;
    await imageCollection.doc(id).get().then((val) => {
          url = val.get('imagePath'),
          removeFile(url),
        });

    return imageCollection
        .doc(id)
        .delete()
        .then((value) => print("Image Deleted"))
        .catchError((e) => print("Failed to delete due to $e"));
  }

  //get position info (longitude and latitude)
  Future<Position> getPosition() async {
    Position coordinate;
    coordinate = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    ).catchError((e) {
      print(e);
    });
    return coordinate;
  }

  //get address info
  Future<String> getAddress(Position coordinate) async {
    String addr;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinate.latitude, coordinate.longitude);
    Placemark place = placemarks[0];
    addr = "${place.locality}, ${place.country}";
    return addr;
  }

  //create album
  Future createAlbum(
    String title,
    String details,
  ) async {
    return albumCollection
      ..add({
        'title': title,
        'details': details,
      });
  }

  //edit album
  editAlbum(
    String id,
    String title,
    String details,
  ) {
    return albumCollection
      ..add({
        'title': title,
        'details': details,
      })
          .then((value) => print("album Updated"))
          .catchError((error) => print("Failed to update album: $error"));
  }

  //delete album
  deleteAlbum(String id) {
    return albumCollection
        .doc(id)
        .delete()
        .then((value) => print("album Deleted"))
        .catchError((e) => print("Failed to delete album due to $e"));
  }

  //put in to album
  Future putInAlbum({required String albumId, required String imageId}) async {
    print("object");
    return albums_images
      ..add({
        'albumId': albumId,
        'imageId': imageId,
      });
  }

  //move out from album
  moveOutAlbum({required String id}) async {
    await albums_images
        .where(
          'imageId',
          isEqualTo: id,
        )
        .get()
        .then((val) => {
              val.docs.forEach((doc) {
                print("remove: ${doc.reference.id}");
                clearImageFromAlbumSingle(doc.reference.id);
              }),
            });
  }

  clearImageFromAlbum(String albumId) async {
    List connection = [];
    await albums_images
        .where('albumId', isEqualTo: albumId)
        .get()
        .then((val) => {
              val.docs.forEach((doc) {
                connection.add(doc.reference.id);
                // print(doc.reference.id);
              }),
            });
    print(connection);
    for (var conn in connection) {
      clearImageFromAlbumSingle(conn);
    }
  }

  clearImageFromAlbumSingle(String conn) {
    return albums_images
        .doc(conn)
        .delete()
        .then((value) => print("album Deleted"))
        .catchError((e) => print("Failed to delete gallery_images due to $e"));
  }
}
