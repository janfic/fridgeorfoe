import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc_provider.dart';
import 'package:fridgeorfoe/blocs/location_bloc.dart';
import 'package:fridgeorfoe/blocs/location_bloc_provider.dart';
import 'package:fridgeorfoe/models/location.dart';
import 'package:fridgeorfoe/screens/add_edit_location.dart';

class LocationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {

  @override
  Widget build(BuildContext context) {

    DatabaseBloc databaseBloc = DatabaseBlocProvider.of(context).databaseBloc;

    return FutureBuilder(
      future: databaseBloc.authentication.currentUserUid(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasData == false) {
          return Container();
        }
        else {
          return StreamBuilder(
            stream: databaseBloc.database.getLocations(snapshot.data),
            builder: (context, AsyncSnapshot<List<Location>> locationsSnapshot) {

              if(locationsSnapshot.connectionState == ConnectionState.waiting || locationsSnapshot.hasData == false) {
                return Container();
              }

              List<_LocationWidget> children = List.generate(locationsSnapshot.data.length, (index) => _LocationWidget(locationsSnapshot.data.elementAt(index)));

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: children,
                  ),
                )
              );
            },
          );
        }
      },
    );
  }

}

class _LocationWidget extends StatelessWidget {

  final Location location;

  _LocationWidget(this.location);

  @override
  Widget build(BuildContext context) {

    ImageProvider image = AssetImage("images/bananas.jpg");
    File file = new File(location.imagePath);
    if(file.existsSync()) {
      image = FileImage(file);
    }
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (c) {
                return DatabaseBlocProvider(
                    databaseBloc: DatabaseBlocProvider.of(context).databaseBloc,
                    child: LocationBlocProvider(
                        locationBloc: LocationBloc(false, location),
                        child: AddEditLocation()));
              },
              fullscreenDialog: true,
            ));
          },
          child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.amberAccent, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.amber.shade50),
          child: Column(
            children: [
              Image(image: image, height: 200, fit: BoxFit.fitHeight,),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(CupertinoIcons.location, color: Colors.amber,),
                    Text(location.name, style: TextStyle(fontSize: 25, color: Colors.amber.shade800)),
                    GestureDetector(
                        onTap: () {
                          print("SEARCH WITH LOCATION");
                        },
                        child: Icon(CupertinoIcons.search, color: Colors.amber)
                    )
                  ]
              ))
            ],
          ),
    )));
  }
}