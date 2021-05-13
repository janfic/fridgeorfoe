import 'dart:async';

import 'package:fridgeorfoe/services/authentication_api.dart';

class AuthenticationBloc {

  final AuthenticationAPI authentication;

  final StreamController<String> _authenticationController = StreamController<String>.broadcast();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>.broadcast();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  void dispose() {
    _authenticationController.close();
  }

  AuthenticationBloc(this.authentication) {
    onAuthChanged();
  }

  void onAuthChanged() {
    authentication.getFirebaseAuth().authStateChanges().listen((user) {
      final String uid = user.uid;
      print("HERERERER");
      addUser.add(uid);
    });
    _logoutController.stream.listen((logout) {
      if(logout) _logOut();
    });
  }

  void _logOut() {
    authentication.logOut();
  }
}