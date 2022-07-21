import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/api/firebase_api.dart';
import 'package:ffs/ui/message/message_page.dart';
import 'package:ffs/ui/message/message_wall_widget.dart';
import 'package:ffs/util/constants.dart';
import 'package:ffs/util/unit/unit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  String? title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String replyMessage = "";
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        Unit.isSignIn = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe3eafc),
      appBar: AppBar(
        title: Text(widget.title!),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            onSelected: (value) {
              if (value == Constants.logout) {
                FirebaseApi.signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Constants.logout,
                child: Text(
                  Constants.logout,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseApi.firebaseStore
                  .orderBy(
                    Constants.timestamp,
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
                            Constants.noMessage,
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
                    onDelete: FirebaseApi.onDeleteMessage,
                    onSwipeMessage: (message) {
                      replyToMessage(message);
                      focusNode.requestFocus();
                    },
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
            onSubmit: FirebaseApi.addMessage,
            focusNode: focusNode,
          )
        ],
      ),
    );
  }

  void replyToMessage(String message) {
    setState(() {
      replyMessage = message;
    });
  }
}
