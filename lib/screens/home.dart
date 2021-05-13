import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc_provider.dart';
import 'package:fridgeorfoe/blocs/item_bloc.dart';
import 'package:fridgeorfoe/blocs/item_bloc_provider.dart';
import 'package:fridgeorfoe/blocs/location_bloc.dart';
import 'package:fridgeorfoe/blocs/location_bloc_provider.dart';
import 'package:fridgeorfoe/models/item.dart';
import 'package:fridgeorfoe/models/location.dart';
import 'package:fridgeorfoe/screens/add_edit_item.dart';
import 'package:fridgeorfoe/screens/add_edit_location.dart';
import 'package:fridgeorfoe/widgets/food_list.dart';
import 'package:fridgeorfoe/widgets/location_list.dart';
import 'package:fridgeorfoe/widgets/shopping_list_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeState();
}

class _HomeState extends State<HomeScreen> with TickerProviderStateMixin {
  DatabaseBloc databaseBloc;

  TabController tabController;

  int index;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
    tabController.addListener(() {setState(() {
      this.index = tabController.index;
    });});
  }

  @override
  Widget build(BuildContext context) {
    databaseBloc = DatabaseBlocProvider.of(context).databaseBloc;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            floatingActionButton: index != 2
                ? FloatingActionButton(
                    child: Icon(CupertinoIcons.add),
                    onPressed: () {
                      if (!tabController.indexIsChanging) {
                        if (index == 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) {
                              return DatabaseBlocProvider(
                                  databaseBloc: DatabaseBlocProvider.of(context)
                                      .databaseBloc,
                                  child: ItemBlocProvider(
                                      itemBloc: ItemBloc(
                                          true,
                                          new Item(
                                              "",
                                              DateTime.now(),
                                              DateTime.now(),
                                              false,
                                              0,
                                              "",
                                              "",
                                              null)),
                                      child: AddEditItem()));
                            },
                            fullscreenDialog: true,
                          ));
                        }
                        if (index == 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) {
                              return DatabaseBlocProvider(
                                  databaseBloc: DatabaseBlocProvider.of(context)
                                      .databaseBloc,
                                  child: LocationBlocProvider(
                                      locationBloc: LocationBloc(
                                          false,
                                          new Location(
                                              "New Location", "", null)),
                                      child: AddEditLocation()));
                            },
                            fullscreenDialog: true,
                          ));
                        }
                      }
                    },
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              bottom: TabBar(
                onTap: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                controller: tabController,
                indicatorWeight: 10,
                labelPadding: EdgeInsets.all(10),
                indicatorColor: Colors.amber.shade200,
                tabs: [
                  Icon(CupertinoIcons.location),
                  Icon(CupertinoIcons.home),
                  Icon(CupertinoIcons.square_list)
                ],
              ),
              centerTitle: true,
              title: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 0),
                  child: Text(
                    "Fridge or Foe",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  )),
              automaticallyImplyLeading: false,
            ),
            body: TabBarView(
              controller: tabController,
              children: [LocationList(), FoodList(), ShoppingListWidget()],
            )));
  }
}
