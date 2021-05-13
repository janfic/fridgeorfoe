import 'dart:async';
import 'dart:io';

import 'package:fridgeorfoe/models/item.dart';
import 'package:fridgeorfoe/models/location.dart';

class LocationBloc {
  bool addOrEdit;
  Location location;

  final StreamController<String> _itemNameController = StreamController<String>.broadcast();
  Sink<String> get changeName => _itemNameController.sink;
  Stream<String> get getName => _itemNameController.stream;

  final StreamController<String> _imagePathController = StreamController<String>.broadcast();
  Sink<String> get changeImagePath => _imagePathController.sink;
  Stream<String> get getImagePath => _imagePathController.stream;

  final StreamController<bool> _saveOrCancelController = StreamController<bool>.broadcast();
  Sink<bool> get saveOrCancel => _saveOrCancelController.sink;
  Stream<bool> get getSaveOrCancel => _saveOrCancelController.stream;

  LocationBloc(this.addOrEdit, this.location) {
    _setListeners().then((value) => _setItem());

  }

  Future<bool> _setListeners() async {
    getName.listen((name) {
      this.location.name = name;
    });
    getImagePath.listen((path) {
      this.location.imagePath = path;
    });
    getSaveOrCancel.listen((saveOrCancel) {
      if(saveOrCancel) {

      }
    });
    return true;
  }

  void _setItem() {
    if(this.addOrEdit == true) {
      location = new Location("", "", null);
    }
    this.changeName.add(location.name);
    this.changeImagePath.add(location.imagePath);
  }
}