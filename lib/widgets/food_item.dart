import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc_provider.dart';
import 'package:fridgeorfoe/blocs/item_bloc.dart';
import 'package:fridgeorfoe/blocs/item_bloc_provider.dart';
import 'package:fridgeorfoe/models/item.dart';
import 'package:fridgeorfoe/screens/add_edit_item.dart';

class FoodItem extends StatefulWidget {
  final Item item;

  FoodItem(this.item);

  @override
  State<StatefulWidget> createState() => new _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(_makePreviewItem());
    if (expanded) widgets.add(_makeExpandedInfoWidget());

    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ));
  }

  Widget _makeExpandedInfoWidget() {
    ImageProvider image = AssetImage("images/bananas.jpg");
    File file = new File(widget.item.imagePath);
    if(file.existsSync()) {
      image = FileImage(file);
    }
    return Padding(
        padding: EdgeInsets.only(top: 0, right: 20, left: 20),
        child: Container(
            padding: EdgeInsets.only(
                top: expanded ? 10 : 0, bottom: expanded ? 10 : 0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.amberAccent, width: 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.amber.shade50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(
                      fit: BoxFit.fitHeight,
                      height: 150,
                      image: image),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      height: 150,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(CupertinoIcons.number,
                                                color: Colors.amber),
                                            Icon(CupertinoIcons.location,
                                                color: Colors.amber),
                                            Icon(
                                                CupertinoIcons
                                                    .calendar_badge_plus,
                                                color: Colors.amber),
                                            Icon(
                                                CupertinoIcons
                                                    .calendar_badge_minus,
                                                color: Colors.amber)
                                          ])),
                                  Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Amount"),
                                          Text("Location"),
                                          Text("Date Acquired"),
                                          Text("Expiration Date")
                                        ],
                                      )),
                                  Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(widget.item.amount.toString()),
                                          Text(widget.item.location),
                                          Text(widget.item.dateAcquired.month
                                                  .toString() +
                                              "/" +
                                              widget.item.dateAcquired.day
                                                  .toString() +
                                              "/" +
                                              widget.item.dateAcquired.year
                                                  .toString()),
                                          Text(widget.item.dateExpired.month
                                                  .toString() +
                                              "/" +
                                              widget.item.dateExpired.day
                                                  .toString() +
                                              "/" +
                                              widget.item.dateExpired.year
                                                  .toString()),
                                        ],
                                      ))
                                ])
                          ]))
                ])));
  }

  Widget _makePreviewItem() {
    ImageProvider image = AssetImage("images/bananas.jpg");
    File file = new File(widget.item.imagePath);
    if(file.existsSync()) {
      image = FileImage(file);
    }

    int daysLeft = widget.item.dateExpired.difference(DateTime.now()).inDays;
    Color expireColor = daysLeft >= 7 ? Colors.green : daysLeft >= 3 ? Colors.yellow.shade800 : Colors.red;
    bool isExpired = daysLeft <= 0;

    return Container(
        padding: EdgeInsets.only(
            top: !expanded ? 10 : 0, bottom: !expanded ? 10 : 0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.amberAccent, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.amber.shade50),
        child: ListTile(
            leading: !expanded
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.amberAccent, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.amber.shade50),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                            fit: BoxFit.fitWidth,
                            width: 50,
                            image: image)))
                : null,
            title: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  widget.item.name,
                  textAlign: expanded ? TextAlign.center : TextAlign.start,
                )),
            tileColor: Colors.amber.shade50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            subtitle: !expanded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        _FoodInfo(
                          widget.item.amount.toString(),
                          Icon(CupertinoIcons.number_circle,
                              color: Colors.amber),
                        ),
                        _FoodInfo(
                            widget.item.location,
                            Icon(
                              CupertinoIcons.location,
                              color: Colors.amber,
                            )),
                        _FoodInfo(
                            widget.item.dateExpired.month.toString() +
                                "/" +
                                widget.item.dateExpired.day.toString() +
                                "/" +
                                widget.item.dateExpired.year.toString(),
                            Icon(
                              isExpired ? CupertinoIcons.trash : CupertinoIcons.clock,
                              color: expireColor,
                            )),
                      ])
                : null,
            onTap: () {
              setState(() {
                this.expanded = !this.expanded;
              });
            },
            onLongPress: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (c) {
                  return DatabaseBlocProvider(
                      databaseBloc: DatabaseBlocProvider.of(context).databaseBloc,
                      child: ItemBlocProvider(
                        itemBloc: ItemBloc(false, widget.item),
                        child: AddEditItem()));
                },
                fullscreenDialog: true,
              ));
            }));
  }
}

class _FoodInfo extends StatelessWidget {
  final String info;
  final Icon icon;

  _FoodInfo(this.info, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.min, children: [icon, Text(info)]));
  }
}
