import 'package:ffs/auth/auth_provider_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthProvider implements AuthProviderBase{
  @override
  Future<FirebaseApp> initializes() {
    // TODO: implement initializes
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

}