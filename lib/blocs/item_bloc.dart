import 'dart:async';
import 'dart:io';

import 'package:fridgeorfoe/models/item.dart';

class ItemBloc {
  bool addOrEdit;
  Item item;

  final StreamController<String> _itemNameController = StreamController<String>.broadcast();
  Sink<String> get changeName => _itemNameController.sink;
  Stream<String> get getName => _itemNameController.stream;

  final StreamController<double> _itemAmountController = StreamController<double>.broadcast();
  Sink<double> get changeAmount => _itemAmountController.sink;
  Stream<double> get getAmount => _itemAmountController.stream;

  final StreamController<String> _itemLocationController = StreamController<String>.broadcast();
  Sink<String> get changeLocation => _itemLocationController.sink;
  Stream<String> get getLocation => _itemLocationController.stream;

  final StreamController<DateTime> _itemAcquiredController = StreamController<DateTime>.broadcast();
  Sink<DateTime> get changeAcquired => _itemAcquiredController.sink;
  Stream<DateTime> get getAcquired => _itemAcquiredController.stream;

  final StreamController<DateTime> _itemExpiredController = StreamController<DateTime>.broadcast();
  Sink<DateTime> get changeExpired => _itemExpiredController.sink;
  Stream<DateTime> get getExpired => _itemExpiredController.stream;

  final StreamController<String> _imagePathController = StreamController<String>.broadcast();
  Sink<String> get changeImagePath => _imagePathController.sink;
  Stream<String> get getImagePath => _imagePathController.stream;

  final StreamController<bool> _saveOrCancelController = StreamController<bool>.broadcast();
  Sink<bool> get saveOrCancel => _saveOrCancelController.sink;
  Stream<bool> get getSaveOrCancel => _saveOrCancelController.stream;

  ItemBloc(this.addOrEdit, this.item) {
    _setListeners().then((value) => _setItem());

  }

  Future<bool> _setListeners() async {
    getName.listen((name) {
      this.item.name = name;
    });
    getAmount.listen((amount) {
      this.item.amount = amount;
    });
    getLocation.listen((location) {
      this.item.location = location;
    });
    getAcquired.listen((date) {
      this.item.dateAcquired = date;
    });
    getExpired.listen((date) {
      this.item.dateExpired = date;
    });
    getImagePath.listen((path) {
      this.item.imagePath = path;
    });
    getSaveOrCancel.listen((saveOrCancel) {
      if(saveOrCancel) {

      }
    });
    return true;
  }

  void _setItem() {
    if(this.addOrEdit == true) {
      item = new Item("", DateTime.now(), DateTime.now(), false, 0,  "Select Location", "", null);
    }
    this.changeName.add(item.name);
    this.changeAmount.add(item.amount);
    this.changeAcquired.add(item.dateAcquired);
    this.changeExpired.add(item.dateExpired);
    this.changeLocation.add(item.location);
    this.changeImagePath.add(item.imagePath);
  }
}