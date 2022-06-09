import 'package:ffs/auth/android_auth_provider.dart';
import 'package:ffs/ui/home/home_page.dart';
import 'package:ffs/util/extension/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:ffs/util/unit/unit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        Unit.isSignIn = true;
      } else {
        Unit.isSignIn = false;
      }
      setState(() {});
    });
  }

  void _signIn() async {
    try {
      final cred = await AuthProvider().signInWithGoogle();
      print(cred);
      setState(() {
        Unit.isSignIn = true;
        Get.to(HomePage());
      });
    } catch (e) {
      "Login failed: $e".toToast;
      // print("Login failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Container(
              margin: const EdgeInsets.all(24),
              child: SignInButton(
                Buttons.Google,
                padding: const EdgeInsets.all(8),
                onPressed: _signIn,
              ),
            )
          ],
        ),
      ),
    );
  }
}
