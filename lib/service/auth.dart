import 'package:chemistry_app/HomeScreen.dart';
import 'package:chemistry_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    print('Google user: $googleUser');
    if (googleUser == null) return; // user canceled

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print('Google Auth tokens: idToken=${googleAuth.idToken}, accessToken=${googleAuth.accessToken}');

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final UserCredential result = await auth.signInWithCredential(credential);
    final User? user = result.user;
    print('Firebase user: $user');
    if (user != null) {
      final userInfoMap = {
        "email": user.email,
        "name": user.displayName,
        "imgUrl": user.photoURL,
        "id": user.uid,
      };
      await DatabaseMethods().addUser(user.uid, userInfoMap);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userName: user.email ?? 'User')),
      );
    }
  }
}
