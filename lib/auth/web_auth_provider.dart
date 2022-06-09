import 'package:ffs/auth/auth_provider_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class _WebAuthProvider implements AuthProviderBase {
  @override
  Future<FirebaseApp> initializes() async {
    return Firebase.apps[0];
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // create new provider
    final provider = GoogleAuthProvider();

    provider.addScope("https://www.googleapis.com/auth/userinfo.email");
    provider.addScope("https://www.googleapis.com/auth/userinfo.profile");
    provider.setCustomParameters({'login_hint': 'user@example.com'});

    // sign in and return user credential
    return await FirebaseAuth.instance.signInWithPopup(provider);
  }
}

class AuthProvider extends _WebAuthProvider {}
