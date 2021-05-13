import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/authentication_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc_provider.dart';
import 'package:fridgeorfoe/models/item.dart';
import 'package:fridgeorfoe/services/firestore_database.dart';

import 'food_item.dart';

class FoodList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  String sortMethod = "Name";

  int _sort(Widget a, Widget b) {
    if(sortMethod == "Name") {
      return _sortByName(a as FoodItem, b as FoodItem);
    }
    else if(sortMethod == "Location") {
      return _sortByLocation(a as FoodItem , b as FoodItem);
    }
    else if(sortMethod == "Expiration Date") {
      return _sortByExpiration(a as FoodItem, b as FoodItem);
    }
    else if(sortMethod == "Date Acquired") {
      return _sortByAcquired(a as FoodItem, b as FoodItem);
    }
    else if(sortMethod == "Amount") {
      return _sortByAmount(a as FoodItem, b as FoodItem);
    }
    return _sortByName(a as FoodItem, b as FoodItem);
  }

  int _sortByAmount(FoodItem a, FoodItem b) {
    return a.item.amount.compareTo(b.item.amount);
  }

  int _sortByAcquired(FoodItem a, FoodItem b) {
    return a.item.dateAcquired.compareTo(b.item.dateAcquired);
  }

  int _sortByExpiration(FoodItem a, FoodItem b) {
    return a.item.dateExpired.compareTo(b.item.dateExpired);
  }

  int _sortByName(FoodItem a, FoodItem b) {
    return a.item.name.compareTo(b.item.name);
  }

  int _sortByLocation(FoodItem a, FoodItem b) {
    return a.item.location.compareTo(b.item.location);
  }

  @override
  Widget build(BuildContext context) {
    DatabaseBloc databaseBloc = DatabaseBlocProvider.of(context).databaseBloc;
    return FutureBuilder(
        future: databaseBloc.authentication.currentUserUid(),
        builder: (context, uidSnapshot) {
          if (!uidSnapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent, width: 2),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.amber.shade50),
              child: Text("Loading"),
            );
          }
          return StreamBuilder(
              stream: databaseBloc.database.getItems(uidSnapshot.data),
              builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                List<Widget> children =
                    List.generate(snapshot.data.length, (index) {
                  return new FoodItem(snapshot.data.elementAt(index));
                });
                children.sort(_sort);
                children.insert(
                    0,
                    Padding(
                        padding: EdgeInsets.only(top:10, left: 10, bottom: 20, right: 10),
                        child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Sort By: ", style: TextStyle(fontSize: 18),),
                              new DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                value: sortMethod,
                                items: [
                                  new DropdownMenuItem(
                                      value: "Name",
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              CupertinoIcons.textformat_abc,
                                              color: Colors.amber,
                                            )),
                                        Text("Name")
                                      ])),
                                  new DropdownMenuItem(
                                      value: "Location",
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(CupertinoIcons.location,
                                                color: Colors.amber)),
                                        Text("Location")
                                      ])),
                                  new DropdownMenuItem(
                                      value: "Expiration Date",
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(CupertinoIcons.trash,
                                                color: Colors.amber)),
                                        Text("Expiration Date")
                                      ])),
                                  new DropdownMenuItem(
                                      value: "Date Acquired",
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(CupertinoIcons.add,
                                                color: Colors.amber)),
                                        Text("Date Acquired")
                                      ])),
                                  new DropdownMenuItem(
                                      value: "Amount",
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(CupertinoIcons.number,
                                                color: Colors.amber)),
                                        Text("Amount")
                                      ]))
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    sortMethod = value;
                                  });
                                },
                              ))
                            ]))));

                return SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: children)));
              });
        });
  }
}
