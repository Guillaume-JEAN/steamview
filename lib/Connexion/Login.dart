import 'package:firebase_auth/firebase_auth.dart';
import 'package:steamview/Database/database.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    initUser(user);
    return user != null ? AppUser(user.uid) : null;
  }

  void initUser(User? user) async {
    if (user == null) return;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user == null) {
        throw Exception("No user found");
      } else {
        await DatabaseService(user.uid).addUser(name);
      }
        return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

}