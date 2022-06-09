import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class AuthProviderBase {
  Future<FirebaseApp> initializes();

  Future<UserCredential> signInWithGoogle();
}
