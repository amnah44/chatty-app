import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_provider_base.dart';

class _AndroidAuthProvider implements AuthProviderBase {
  @override
  Future<FirebaseApp> initializes() async {
    return await Firebase.initializeApp(
        name: "Chatty",
        options: const FirebaseOptions(
            apiKey: "AIzaSyDlVY7dMaIRr1in-7xW6ZmZsdbPvk3QujQ",
            authDomain: "flutter-firbase-sample.firebaseapp.com",
            projectId: "flutter-firbase-sample",
            storageBucket: "flutter-firbase-sample.appspot.com",
            messagingSenderId: "733875005713",
            appId: "1:733875005713:android:1a59ff44f656771e7b04b0",
            measurementId: "G-83FMDLDN5E"));
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class AuthProvider extends _AndroidAuthProvider {}
