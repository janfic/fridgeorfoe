import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'location.dart';

class Item {
  String name;
  DateTime dateAcquired;
  DateTime dateExpired;
  bool isExpired;
  double amount;
  String imagePath;
  String location;
  String docId;

  Item(this.name, this.dateAcquired, this.dateExpired, this.isExpired,
      this.amount, this.location, this.imagePath, this.docId);

  static Item fromDoc(DocumentSnapshot doc) {
    Timestamp acquired = doc["date_acquired"];
    Timestamp expired = doc["date_expired"];

    Item i = new Item(
        doc["name"],
        acquired.toDate(),
        expired.toDate(),
        doc["is_expired"],
        doc["amount"].toDouble(),
        doc["location"],
        doc["image_path"],
        doc.reference.id);
    return i;
  }

  static dynamic toDoc(Item item) {
    return {
      "name": item.name,
      "date_acquired": item.dateAcquired,
      "date_expired": item.dateExpired,
      "location": item.location,
      "amount": item.amount,
      "is_expired": item.isExpired,
      "image_path": item.imagePath
    };
  }
}
