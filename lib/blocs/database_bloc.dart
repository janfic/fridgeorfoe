import 'dart:async';

import 'package:fridgeorfoe/models/item.dart';
import 'package:fridgeorfoe/models/location.dart';
import 'package:fridgeorfoe/models/shopping_item.dart';
import 'package:fridgeorfoe/services/authentication_api.dart';
import 'package:fridgeorfoe/services/database_api.dart';

class DatabaseBloc {
  final DatabaseAPI database;
  final AuthenticationAPI authentication;

  final StreamController<List<Item>> _itemsController = StreamController<List<Item>>.broadcast();
  Sink<List<Item>> get _addItemList => _itemsController.sink;
  Stream<List<Item>> get getItems => _itemsController.stream;

  final StreamController<List<Location>> _locationsController = StreamController<List<Location>>.broadcast();
  Sink<List<Location>> get _addLocationList => _locationsController.sink;
  Stream<List<Location>> get getLocations => _locationsController.stream;

  final StreamController<List<ShoppingItem>> _shoppingListController = StreamController<List<ShoppingItem>>.broadcast();
  Sink<List<ShoppingItem>> get _addShoppingList => _shoppingListController.sink;
  Stream<List<ShoppingItem>> get getShoppingList => _shoppingListController.stream;

  DatabaseBloc(this.authentication, this.database) {
    _startListeners();
  }

  void dispose() {
    _itemsController.close();
    _locationsController.close();
    _shoppingListController.close();
  }

  void _startListeners() {
    authentication.currentUserUid().then((userId) async {
      await database.createUser(userId);
      database.getItems(userId).listen((itemList) {
        _addItemList.add(itemList);
      });
      database.getLocations(userId).listen((locationsList) {
        _addLocationList.add(locationsList);
      });
      database.getShoppingList(userId).listen((shoppingList) {
        _addShoppingList.add(shoppingList);
      });
    });
  }
}