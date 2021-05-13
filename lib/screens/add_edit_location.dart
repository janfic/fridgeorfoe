import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc_provider.dart';
import 'package:fridgeorfoe/blocs/location_bloc.dart';
import 'package:fridgeorfoe/blocs/location_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddEditLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddEditLocationState();

}

class _AddEditLocationState extends State<AddEditLocation> {
  @override
  Widget build(BuildContext context) {
    DatabaseBloc databaseBloc = DatabaseBlocProvider.of(context).databaseBloc;
    LocationBloc locationBloc = LocationBlocProvider.of(context).locationBloc;
    return Scaffold(
        backgroundColor: Colors.amber.shade50,
        appBar: AppBar(
          title: Text("Edit: " + locationBloc.location.name.toString()),
          actions: [
            GestureDetector(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Icon(CupertinoIcons.trash)),
              onTap: () async {
                Navigator.of(context).pop();
                databaseBloc.database.removeLocation(
                    await databaseBloc.authentication.currentUserUid(),
                    locationBloc.location);
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
                      stream: locationBloc.getImagePath,
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
                        locationBloc.changeImagePath.add(image.path);
                      },
                      child: Text("Choose Image from Gallery")),
                  OutlinedButton(
                      onPressed: () async {
                        PickedFile image = await ImagePicker()
                            .getImage(source: ImageSource.camera);
                        locationBloc.changeImagePath.add(image.path);
                      },
                      child: Text("Take Photo with Camera")),
                  _makeEditableField(
                      icon: Icon(CupertinoIcons.textformat_abc),
                      name: "Location Name",
                      stream: locationBloc.getName,
                      sink: locationBloc.changeName),
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
                          await databaseBloc.database.addLocation(uid, locationBloc.location);
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

  Widget _makeEditableField(
      {Icon icon,
        String name,
        onTap,
        Stream stream,
        Sink sink}) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                  initialValue: snapshot.data.toString(),
                  onChanged: (data) {
                    sink.add(data);
                  },
                  onTap: onTap,
                  obscureText: false,
                  decoration: InputDecoration(
                      icon: icon,
                      labelText: name,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ))));
        });
  }
}