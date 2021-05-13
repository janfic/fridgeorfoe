import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fridgeorfoe/models/item.dart';
import 'package:fridgeorfoe/models/location.dart';
import 'package:fridgeorfoe/models/shopping_item.dart';
import 'package:fridgeorfoe/services/database_api.dart';

class FirestoreDatabase implements DatabaseAPI {
  final String _userDataCollection = "userdata";

  @override
  Future<bool> createUser(String uid) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .get();
    FirebaseFirestore.instance.collection(_userDataCollection).doc(uid).snapshots().listen((event) {
      print(event.id);
    });
    print("----------------------------------");
    if (doc.id == uid) {
      return true;
    } else {
      Item item = new Item("Bananas", new DateTime(2021, 5, 7),
          new DateTime(2021, 5, 7), false, 5, 'Fridge', "", uid);
      DocumentReference doc =
          FirebaseFirestore.instance.collection(_userDataCollection).doc(uid);
      DocumentReference itemStub = await doc.collection("items").add({
        'name': item.name,
        'date_acquired': item.dateAcquired,
        'date_expired': item.dateExpired,
        'is_expired': item.isExpired,
        'amount': item.amount,
        'location': item.location,
        'image_path' : item.imagePath
      });
      item.docId = itemStub.id;
      DocumentReference locationStub =
          await doc.collection("locations").add({'name': 'Fridge', 'image_path' : ""});
    }
    return true;
  }

  @override
  Future<bool> addItem(String uid, Item item) async {
    FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection('items')
        .doc(item.docId)
        .set(Item.toDoc(item));
    return true;
  }

  @override
  Future<bool> addLocation(String uid, Location location) async {
    FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection('locations')
        .doc(location.docId)
        .set(Location.toDoc(location));
    return true;
  }

  @override
  Future<bool> addShoppingListItem(String uid, ShoppingItem item) async {
      FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection('shopping_list')
        .doc(item.docId)
        .set(ShoppingItem.toDoc(item));
    return true;
  }

  @override
  Stream<List<Item>> getItems(String uid) {
    CollectionReference col = FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection('items');
    return col.snapshots().map((QuerySnapshot snapshot) {
      if(snapshot.docs.isNotEmpty) {
        List<Item> _items =
        snapshot.docs.map((doc) => Item.fromDoc(doc)).toList();
        return _items;
      }
      else {
        return <Item>[];
      }
    });
  }

  @override
  Stream<List<Location>> getLocations(String uid) {
    CollectionReference col = FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection('locations');
    return col.snapshots().map((QuerySnapshot snapshot) {
      if(snapshot.docs.isNotEmpty) {
        List<Location> _locations =
        snapshot.docs.map((doc) => Location.fromDoc(doc)).toList();
        return _locations;
      }
      else {
        return <Location>[];
      }
    });
  }

  @override
  Stream<List<ShoppingItem>> getShoppingList(String uid) {
    CollectionReference col = FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection('shopping_list');
    return col.snapshots().map((QuerySnapshot snapshot) {
      if(snapshot.docs.isNotEmpty) {
        List<ShoppingItem> _items =
        snapshot.docs.map((doc) => ShoppingItem.fromDoc(doc)).toList();
        return _items;
      }
      else {
        return <ShoppingItem>[];
      }
    });
  }

  Future<bool> removeItem(String uid, Item item) async {
    FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection("items")
        .doc(item.docId)
        .delete();
    return true;
  }

  Future<bool> removeLocation(String uid, Location location) async {
    FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection("locations")
        .doc(location.docId)
        .delete();
    return true;
  }

  Future<bool> removeShoppingListItem(String uid, ShoppingItem item) async {
    FirebaseFirestore.instance
        .collection(_userDataCollection)
        .doc(uid)
        .collection("shopping_list")
        .doc(item.docId)
        .delete();
    return true;
  }
}
