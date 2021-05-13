import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'authentication_bloc.dart';

class DatabaseBlocProvider extends InheritedWidget {
  final DatabaseBloc databaseBloc;

  const DatabaseBlocProvider(
      {Key key, Widget child, this.databaseBloc})
      : super(key: key, child: child);

  static DatabaseBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<DatabaseBlocProvider>()
        as DatabaseBlocProvider);
  }

  @override
  bool updateShouldNotify(DatabaseBlocProvider old) =>
      databaseBloc != old.databaseBloc;
}
