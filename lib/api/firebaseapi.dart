import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minecraft_gallery/models/ImageDetails.dart';

class FirebaseApi {
  final CollectionReference imageCollection =
      FirebaseFirestore.instance.collection('images');

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<void> removeFile(String id) async {
    String url;
    await imageCollection.doc(id).get().then((val) => {
          url = val.get('imagePath'),
          FirebaseStorage.instance.refFromURL(url).delete(),
        });

    return imageCollection
        .doc(id)
        .delete()
        .then((value) => print("Image Deleted"))
        .catchError((e) => print("Failed to delete due to $e"));
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future addImage(String title, String details, String url) async {
    print("--------------------initialling position");
    var coordinate = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    ).catchError((e) {
      print(e);
    });
    print("--------------------initialling get coordinate");
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinate.latitude, coordinate.longitude);
    Placemark place = placemarks[0];
    String position = "${place.locality}, ${place.country}";
    print("--------------------initialling finish and start to upload");
    return imageCollection
      ..add({
        'imagePath': url,
        'longitude': coordinate.longitude,
        'latitude': coordinate.latitude,
        'position': position,
        'time': DateTime.now(),
        'title': title,
        'details': details,
      });
  }

  Future<void> updateUser(String id, String title, String details) {
    return imageCollection
        .doc(id)
        .update({
          'title': title,
          'details': details,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
