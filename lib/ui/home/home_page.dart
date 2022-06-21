import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/ui/home/customFloatingActionButton.dart';
import 'package:ffs/ui/message/message_page.dart';
import 'package:ffs/ui/message/message_wall_widget.dart';
import 'package:ffs/util/extension/toast.dart';
import 'package:ffs/util/unit/unit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  String? title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firebaseStore = FirebaseFirestore.instance.collection('chatty');
  bool _isFloatingButtonExtended = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        Unit.isSignIn = true;
      }
      // } else {
      //   Unit.isSignIn = false;
      // }
      setState(() {});
    });
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      Get.back();
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            onSelected: (value) {
              if (value == 'logout') {
                _signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          )
        ],
      ),
      backgroundColor: const Color(0xffe3eafc),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.minScrollExtent) {
            _isFloatingButtonExtended = false;
          } else if (_isFloatingButtonExtended) {
            _isFloatingButtonExtended = true;
          }
          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseStore
                    .orderBy(
                      'timestamp',
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/img.png",
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            const Text(
                              "No message for now",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
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
                      child: SpinKitDualRing(
                        color: Colors.blue,
                        size: 64,
                      ),
                    );
                  }
                },
              ),
            ),
            MessagePage(
              onSubmit: _addMessage,
            )
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        isExtended: _isFloatingButtonExtended,
        onClick: () {},
      ),
    );
  }
}
