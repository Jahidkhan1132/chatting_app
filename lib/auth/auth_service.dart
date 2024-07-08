import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

//  instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
  Future<UserCredential> signInWithEmailPassword(String email, String password) async{

    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'email':email,
        'password':password


      });
      return userCredential;
    } on FirebaseException catch(e){

      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential>  signUpWithEmailPassword(String email, String password) async{
    try{
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'email':email,
        'password':password


      });
      return userCredential;

    } on FirebaseException catch(e){

      throw Exception(e.code);

    }
  }
  // sign out
Future<void> signOut()async{

    return auth.signOut();
}

}