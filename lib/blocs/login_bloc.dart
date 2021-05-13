import 'dart:async';

import 'package:fridgeorfoe/blocs/authentication_bloc.dart';
import 'package:fridgeorfoe/services/authentication_api.dart';

class LoginBloc {

  String _email = '';
  String _password = '';
  bool _validEmail = false, _validPassword = false;
  String loginOrSignup = null;
  String uid = "NO UID";
  final AuthenticationAPI authenticationAPI;

  final StreamController<String> _emailController = StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _loginOrSignUpController = StreamController<String>.broadcast();
  Sink<String> get setloginOrSignUp => _loginOrSignUpController.sink;
  Stream<String> get getloginOrSignUp => _loginOrSignUpController.stream;

  final StreamController<String> _passwordController = StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  final StreamController<String> _loginOrSignUpButtonController = StreamController<String>.broadcast();
  Sink<String> get loginOrSignUpButtonPress => _loginOrSignUpButtonController.sink;
  Stream<String> get getLoginOrSignUpButton => _loginOrSignUpButtonController.stream;

  final StreamController<String> _loginOrSignUpSuccessfulController = StreamController<String>.broadcast();
  Stream<String> get loginSuccessful => _loginOrSignUpSuccessfulController.stream;

  LoginBloc(this.authenticationAPI) {
    _startListeners();
  }

  void _startListeners() {
    email.listen((email) async {
      _email = email;
      _validEmail = true;
      if(_validPassword) loginOrSignup = "Login";
      setloginOrSignUp.add(loginOrSignup);
    }).onError((email) {
      _email = email;
      _validEmail = false;
      loginOrSignup = null;
      setloginOrSignUp.add(null);
    });
    password.listen((password) async {
      _password = password;
      _validPassword = true;
      if(_validEmail) loginOrSignup = "Login";
      setloginOrSignUp.add(loginOrSignup);
    }).onError((password){
      _password = password;
      _validPassword = false;
      loginOrSignup = null;
      setloginOrSignUp.add(null);
    });
    getLoginOrSignUpButton.listen((string) async {
      print("getLoginOrSignUpButton.listen : " + string.toString() + " " + loginOrSignup.toString() );
      if(loginOrSignup != null) {
        loginOrSignup = await _isLoginOrSignUp();
        if(loginOrSignup == 'Login') _login();
        if(loginOrSignup == 'Sign-Up') _signUp();
        if(loginOrSignup == 'wrong-password') setloginOrSignUp.add("wrong-password");
      }
    });
  }

  Future<String> _isLoginOrSignUp() async {
      String result = await authenticationAPI.loginWithEmailAndPassword(email: _email, password: _password.trim());
      print(result);
      if(result == 'wrong-password') return 'wrong-password';
      if(result == 'user-not-found') return 'Sign-Up';
      return "Login";
  }

  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@') && email.contains('.')) {
      sink.add(email);
    } else if (email.length > 0) {
      sink.addError('Enter a valid email');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 6) {
          sink.add(password);
        } else if (password.length > 0) {
          sink.addError('Password needs to be at least 6 characters');
        }
      });

  _login() async {
    String uid = await authenticationAPI.loginWithEmailAndPassword(email: _email, password: _password);
    if(uid != 'wrong-password' || uid != 'user-not-found') {
      _loginOrSignUpSuccessfulController.sink.add(uid);
    }
    else {
      _loginOrSignUpSuccessfulController.sink.add("NO UID");
    }
  }

  _signUp() async {
    String uid = await authenticationAPI.createUserWithEmailAndPassword(email: _email, password: _password);
    _loginOrSignUpSuccessfulController.sink.add(uid);
  }
}