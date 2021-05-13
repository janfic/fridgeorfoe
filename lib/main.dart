import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/authentication_bloc.dart';
import 'package:fridgeorfoe/blocs/authentication_block_provider.dart';
import 'package:fridgeorfoe/blocs/database_bloc.dart';
import 'package:fridgeorfoe/screens/home.dart';
import 'package:fridgeorfoe/screens/login.dart';
import 'package:fridgeorfoe/services/firestore_authentication.dart';
import 'package:fridgeorfoe/services/firestore_database.dart';

import 'blocs/database_bloc_provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final AuthenticationBloc authenticationBloc =
      AuthenticationBloc(FirestoreAuthentication());

  @override
  Widget build(BuildContext context) {
    return AuthenticationBlocProvider(
        authenticationBloc: authenticationBloc,
        child: MaterialApp(
          title: 'Fridge or Foe',
          theme: ThemeData(
            primarySwatch: Colors.amber,
            accentColor: Colors.amberAccent,
          ),
          initialRoute: "/login",
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => DatabaseBlocProvider(
                databaseBloc: DatabaseBloc(
                    authenticationBloc.authentication, FirestoreDatabase()),
                child: DefaultTabController(length: 3, child: HomeScreen()))
          },
        ));
  }
}
