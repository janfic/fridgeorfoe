import 'package:firebase_auth/firebase_auth.dart';
import 'package:fridgeorfoe/services/authentication_api.dart';

class FirestoreAuthentication implements AuthenticationAPI {
  final FirebaseAuth _firestoreAuth = FirebaseAuth.instance;
  bool _isLocal = false;

  @override
  Future<String> createUserWithEmailAndPassword({ String email,  String password}) async {
    final UserCredential user = await _firestoreAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.user.uid;
  }

  @override
  Future<String> currentUserUid() async {
    if(_isLocal) return "local";
    String user = await _firestoreAuth.currentUser.uid;
    return user;
  }

  @override
  getFirebaseAuth() {
    return _firestoreAuth;
  }

  @override
  Future<bool> isEmailVerified() async {
    User user =  await _firestoreAuth.currentUser;
    return user.emailVerified;
  }

  @override
  Future<String> localLogin() async {
    String localUID = await "local";
    _isLocal = true;
    return localUID;
  }

  @override
  Future<void> logOut() async {
    return _firestoreAuth.signOut();
  }

  @override
  Future<bool> isLocalUser() async {
    return _isLocal;
  }

  @override
  Future<String> loginWithEmailAndPassword({ String email,  String password}) async {
    try {
      final UserCredential user = await _firestoreAuth.signInWithEmailAndPassword(email: email, password: password);
      return user.user.uid;
    }
    catch( e ) {
        return e.code;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    User user =  _firestoreAuth.currentUser;
    return await user.sendEmailVerification();
  }
}