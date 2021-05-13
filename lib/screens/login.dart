import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgeorfoe/blocs/authentication_bloc.dart';
import 'package:fridgeorfoe/blocs/authentication_block_provider.dart';
import 'package:fridgeorfoe/blocs/login_bloc.dart';
import 'package:fridgeorfoe/services/authentication_api.dart';
import 'package:fridgeorfoe/services/firestore_authentication.dart';
import 'package:fridgeorfoe/services/firestore_database.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc;
  AuthenticationBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
    loginBloc = new LoginBloc(authBloc.authentication);
    loginBloc.loginSuccessful.listen((event) {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(40)),
                        Text(
                          "Fridge or Foe",
                          style: TextStyle(color: Colors.amber, fontSize: 40),
                        ),
                        Text("Food Management made Easy",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 15)),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: StreamBuilder(
                              stream: loginBloc.email,
                              builder: (context, snapshot) => TextFormField(
                                  onChanged: loginBloc.emailChanged.add,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.person),
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ))),
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: StreamBuilder(
                              stream: loginBloc.password,
                              builder: (context, snapshot) => TextFormField(
                                  onChanged: loginBloc.passwordChanged.add,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.lock),
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ))),
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: StreamBuilder(
                                stream: loginBloc.getloginOrSignUp,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  String text =
                                      "Enter Credentials to Login or Sign-Up";
                                  if (snapshot.hasData) {
                                    print(snapshot.data);
                                    if (snapshot.data == 'Sign-Up')
                                      text = 'Sign-Up';
                                    if (snapshot.data == 'wrong-password')
                                      text = "Incorrect Password";
                                    if (snapshot.data == 'Login')
                                      text = "Login";
                                  }
                                  return OutlinedButton(
                                            onPressed: () async {
                                              loginBloc.loginOrSignUpButtonPress.add(snapshot.data);
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Text(
                                                  text,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )));
                                      })
                                ),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("or")),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
                                },
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      "Continue without Logging In",
                                      style: TextStyle(fontSize: 15),
                                    )))),
                      ],
                    )))));
  }
}
