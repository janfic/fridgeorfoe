import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fridgeorfoe/models/item.dart';
import 'package:fridgeorfoe/models/location.dart';
import 'package:fridgeorfoe/models/shopping_item.dart';

abstract class DatabaseAPI {

  Future<bool> createUser(String uid);

  Future<bool> addItem(String uid, Item item);
  Future<bool> addLocation(String uid, Location location);
  Future<bool> addShoppingListItem(String uid, ShoppingItem item);

  Future<bool> removeItem(String uid, Item item);
  Future<bool> removeLocation(String uid, Location location);
  Future<bool> removeShoppingListItem(String uid, ShoppingItem item);

  Stream<List<Item>> getItems(String uid);
  Stream<List<Location>> getLocations(String uid);
  Stream<List<ShoppingItem>> getShoppingList(String uid);

}