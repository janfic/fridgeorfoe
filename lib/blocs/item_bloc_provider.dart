import 'package:flutter/cupertino.dart';

import 'item_bloc.dart';

class ItemBlocProvider extends InheritedWidget {
  final ItemBloc itemBloc;

  const ItemBlocProvider({Key key, Widget child, this.itemBloc})
      : super(key: key, child: child);

  static ItemBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ItemBlocProvider>()
        as ItemBlocProvider);
  }

  @override
  bool updateShouldNotify(ItemBlocProvider old) => itemBloc != old.itemBloc;
}
