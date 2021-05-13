import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  bool bought;
  String name;
  String docId;
  ShoppingItem({this.name, this.bought, this.docId});

  static ShoppingItem fromDoc(DocumentSnapshot doc) {
    return new ShoppingItem(
        name: doc['name'],
        bought: doc['bought'],
        docId: doc.id
    );
  }

  static dynamic toDoc(ShoppingItem item) {
    return {
      'name': item.name,
      'bought' : item.bought
    };
  }
}