import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationAPI {
  FirebaseAuth getFirebaseAuth();
  Future<String> currentUserUid();
  Future<void> logOut();
  Future<String> localLogin();
  Future<bool> isLocalUser();
  Future<String> loginWithEmailAndPassword({ String email,  String password});
  Future<String> createUserWithEmailAndPassword({ String email,  String password});
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}