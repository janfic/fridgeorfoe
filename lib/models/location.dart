import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String name;
  String docId;
  String imagePath;
  //Picture picture;

  Location(this.name,  this.imagePath, this.docId);

  static Location fromDoc(DocumentSnapshot doc) {
      Location l = new Location(doc["name"], doc["image_path"], doc.reference.id);
    return l;
  }

  static dynamic toDoc(Location location) {
    return {
      "name" : location.name,
      "image_path" : location.imagePath
    };
  }
}