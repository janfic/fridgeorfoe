import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/blocs/database_bloc_provider.dart';
import 'package:fridgeorfoe/models/shopping_item.dart';

class ShoppingListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseBloc databaseBloc = DatabaseBlocProvider.of(context).databaseBloc;
    TextEditingController controller = new TextEditingController();
    return SingleChildScrollView( child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            FutureBuilder(
                future: databaseBloc.authentication.currentUserUid(),
                builder: (context, uidSnapshot) {
                  if (!uidSnapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent, width: 2),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Colors.amber.shade50),
                      child: Text("Loading"),
                    );
                  }
                  return StreamBuilder(
                      stream: databaseBloc.database
                          .getShoppingList(uidSnapshot.data),
                      builder: (context,
                          AsyncSnapshot<List<ShoppingItem>> snapshot) {
                        if (!snapshot.hasData) return Text("Loading...");
                        List<Widget> children =
                            List.generate(snapshot.data.length, (index) {
                          return _makeShoppingListItem(
                              snapshot.data.elementAt(index),
                              databaseBloc,
                              uidSnapshot.data);
                        });
                        return Column(
                          children: children,
                        );
                      });
                }),
            Padding(padding: EdgeInsets.all(10), child:TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: Icon(CupertinoIcons.add),
                      onTap: () async {
                        String uid =
                            await databaseBloc.authentication.currentUserUid();
                        ShoppingItem item = new ShoppingItem(
                            name: controller.text.trim(),
                            bought: false,
                            docId: null);
                        databaseBloc.database.addShoppingListItem(uid, item);
                        controller.clear();
                      },
                    ),
                    labelText: "Add Item",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ))))
          ],
        )));
  }

  Widget _makeShoppingListItem(
      ShoppingItem item, DatabaseBloc databaseBloc, String uid) {
    return Padding(padding: EdgeInsets.all(10), child:Dismissible(
        onDismissed: (dismissDirection) {
          databaseBloc.database.removeShoppingListItem(uid, item);
        },
        key: Key(item.name),
        child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.amberAccent, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.amber.shade50),
            child: ListTile(
                title: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      item.name,
                      textAlign: TextAlign.start,
                    )),
                trailing: GestureDetector(
                    onTap: () {
                      item.bought = !item.bought;
                      databaseBloc.database.addShoppingListItem(uid, item);
                    },
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: item.bought
                            ? Icon(
                                CupertinoIcons.checkmark_alt,
                                color: Colors.green,
                              )
                            : Icon(CupertinoIcons.square))),
                tileColor: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))))));
  }
}
