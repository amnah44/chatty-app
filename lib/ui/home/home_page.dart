import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/auth//stub.dart'
    if (dart.library.io) 'package:ffs/auth/android_auth_provider.dart'
    if (dart.library.html) 'package:ffs/auth/web_auth_provider.dart';
import 'package:ffs/ui/message/message_page.dart';
import 'package:ffs/ui/message/message_wall_widget.dart';
import 'package:ffs/util/extension/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  String? title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSignIn = false;
  final firebaseStore = FirebaseFirestore.instance.collection('chatty');

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        _isSignIn = true;
      } else {
        _isSignIn = false;
      }
      setState(() {});
    });
  }

  void _signIn() async {
    try {
      final cred = await AuthProvider().signInWithGoogle();
      // print(cred);
      setState(() {
        _isSignIn = true;
      });
    } catch (e) {
      print("Login failed: $e");
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _isSignIn = false;
      'sign out is successful'.toToast();
    });
  }

  void _addMessage(String message) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await firebaseStore.add({
        'auth': user.displayName ?? "",
        'id': user.uid,
        'phonenumber': user.phoneNumber ?? "",
        'timestamp': Timestamp.now().millisecondsSinceEpoch,
        'profileImage': user.photoURL ??
            "https://avatars.githubusercontent.com/u/59895284?v=4",
        'message': message,
      });
    }
  }

  void _onDeleteMessage(String docId) async {
    await firebaseStore.doc(docId).delete();
    'deleted message'.toToast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        centerTitle: true,
        actions: [
          if (_isSignIn)
            InkWell(
              onTap: _signOut,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
      backgroundColor: const Color(0xffe3eafc),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firebaseStore.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/img.png",
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          const Text(
                            "No message for now",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return MessageWallWidget(
                    messages: snapshot.data!.docs,
                    onDelete: _onDeleteMessage,
                  );
                } else {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 64,
                    ),
                  );
                }
              },
            ),
          ),
          (_isSignIn)
              ? MessagePage(
                  onSubmit: _addMessage,
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: _signIn,
                  ),
                )
        ],
      ),
    );
  }
}
