import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc_provider.dart';
import 'package:fridgeorfoe/blocs/item_bloc.dart';
import 'package:fridgeorfoe/blocs/item_bloc_provider.dart';
import 'package:fridgeorfoe/models/location.dart';
import 'package:image_picker/image_picker.dart';

class AddEditItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddEditItemState();
}

class _AddEditItemState extends State<AddEditItem> {

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  String selectedLocation;

  @override
  Widget build(BuildContext context) {
    DatabaseBloc databaseBloc = DatabaseBlocProvider.of(context).databaseBloc;
    ItemBloc itemBloc = ItemBlocProvider.of(context).itemBloc;

    selectedLocation = itemBloc.item.location;
    return Scaffold(
        backgroundColor: Colors.amber.shade50,
        appBar: AppBar(
          title: Text("Edit: " + itemBloc.item.name.toString()),
          actions: [
            GestureDetector(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Icon(CupertinoIcons.trash)),
              onTap: () async {
                Navigator.of(context).pop();
                databaseBloc.database.removeItem(
                    await databaseBloc.authentication.currentUserUid(),
                    itemBloc.item);
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Column(
            children: [
              StreamBuilder(
                  stream: itemBloc.getImagePath,
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    ImageProvider image = AssetImage("images/bananas.jpg");
                    if (snapshot.hasData) {
                      File file = new File(snapshot.data);
                      if (file.existsSync()) image = FileImage(file);
                    }
                    return Image(
                        fit: BoxFit.fitWidth, height: 200, image: image);
                  }),
              OutlinedButton(
                  onPressed: () async {
                    PickedFile image = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    itemBloc.changeImagePath.add(image.path);
                  },
                  child: Text("Choose Image from Gallery")),
              OutlinedButton(
                  onPressed: () async {
                    PickedFile image = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    itemBloc.changeImagePath.add(image.path);
                  },
                  child: Text("Take Photo with Camera")),
              _makeEditableField(
                  icon: Icon(CupertinoIcons.textformat_abc),
                  name: "Item Name",
                  stream: itemBloc.getName,
                  sink: itemBloc.changeName),
              _makeEditableField(
                  icon: Icon(CupertinoIcons.number),
                  name: "Amount",
                  isNumbers: true,
                  stream: itemBloc.getAmount,
                  sink: itemBloc.changeAmount),

              _makeEditableField(
                  icon: Icon(CupertinoIcons.add),
                  name: "Date Acquired",
                  onTap: () => chooseDate(controller1, itemBloc.changeAcquired),
                  controller: controller1,
                  stream: itemBloc.getAcquired,
                  sink: itemBloc.changeAcquired),
              _makeEditableField(
                  icon: Icon(CupertinoIcons.trash),
                  name: "Expiration Date",
                  onTap: () => chooseDate(controller2, itemBloc.changeExpired),
                  controller: controller2,
                  stream: itemBloc.getExpired,
                  sink: itemBloc.changeExpired),
              Padding(padding: EdgeInsets.all(10), child: _makeDropDown(databaseBloc, itemBloc)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade500),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.only(left: 35, right: 35))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green.shade500),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.only(left: 40, right: 40))),
                    onPressed: () async {
                      String uid =
                          await databaseBloc.authentication.currentUserUid();
                      await databaseBloc.database.addItem(uid, itemBloc.item);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))
              ])
            ],
          )),
        ));
  }

  Widget _makeDropDown(DatabaseBloc databaseBloc, ItemBloc itemBloc) {
    return
          FutureBuilder(
        future: databaseBloc.authentication.currentUserUid(),
        builder: (context, uidSnapshot) {
          if(!uidSnapshot.hasData) return Text("Loading...");
          return StreamBuilder(
              stream: databaseBloc.database.getLocations(uidSnapshot.data),
              builder: (context, AsyncSnapshot<List<Location>> locationsSnapshot) {
                if(!locationsSnapshot.hasData) return Text("Loading...");

                List<DropdownMenuItem<String>> items = locationsSnapshot.data.map(
                        (location) => new DropdownMenuItem<String>(
                        value: location.name.trim(),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(location.name, textAlign: TextAlign.center,)))).toList();
                items.insert(0, new DropdownMenuItem<String>(child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Select Location")), value: "Select Location",));

                return StreamBuilder(
                    stream: itemBloc.getLocation,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      print(selectedLocation);
                      return  Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: DropdownButtonHideUnderline(child: DropdownButton(
                            isExpanded: true,
                            value: selectedLocation == null || selectedLocation.length == 0 ? "Select Location" : selectedLocation,
                            underline: null,
                            onChanged: (String newValue) {
                              itemBloc.changeLocation.add(newValue);
                              selectedLocation = newValue;
                              print(newValue);
                            },
                            items: items
                        )),
                      );});
              });
        });
  }

  void chooseDate(controller, sink) async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(2010),
        lastDate: new DateTime(2050));
    if(date != null) {
      sink.add(date);
      controller.text = formatDate(date);
      controller.notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    return date.month.toString() +
        " / " +
        date.day.toString() +
        " / " +
        date.year.toString();
  }

  Widget _makeEditableField(
      {Icon icon,
      String name,
      bool isNumbers = false,
      onTap,
      TextEditingController controller,
      Stream stream,
      Sink sink}) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (controller != null && snapshot.data is DateTime)
            controller.text = formatDate(snapshot.data as DateTime);
          return Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                  initialValue:
                      controller != null ? null : snapshot.data.toString(),
                  onChanged: (data) {
                    if (isNumbers)
                      sink.add(double.parse(data));
                    else
                      sink.add(data);
                  },
                  controller: controller,
                  onTap: onTap,
                  obscureText: false,
                  inputFormatters:
                      isNumbers ? [FilteringTextInputFormatter.digitsOnly] : [],
                  decoration: InputDecoration(
                      icon: icon,
                      labelText: name,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ))));
        });
  }
}
