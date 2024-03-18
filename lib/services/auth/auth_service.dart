import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //INSTANCE OF AUTH
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //Sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info in a seqarate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': email},
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      //create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save user info in a seqarate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': email},
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.email);
      //e.code
    }
  }

  //Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
  //errors
}
