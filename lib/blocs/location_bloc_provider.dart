import 'package:flutter/cupertino.dart';

import 'item_bloc.dart';
import 'location_bloc.dart';

class LocationBlocProvider extends InheritedWidget {
  final LocationBloc locationBloc;

  const LocationBlocProvider({Key key, Widget child, this.locationBloc})
      : super(key: key, child: child);

  static LocationBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LocationBlocProvider>()
        as LocationBlocProvider);
  }

  @override
  bool updateShouldNotify(LocationBlocProvider old) =>
      locationBloc != old.locationBloc;
}
