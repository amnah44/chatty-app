import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/auth/android_auth_provider.dart';
import 'package:ffs/model/slide_items_data.dart';
import 'package:ffs/ui/home/home_page.dart';
import 'package:ffs/ui/login/slide_login_dots.dart';
import 'package:ffs/ui/login/slide_login_widget.dart';
import 'package:ffs/util/extension/toast.dart';
import 'package:ffs/util/unit/unit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';

import '../../util/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final firebaseStore = FirebaseFirestore.instance.collection(Constants.chatty);
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    //check if there is user or no
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        Unit.isSignIn = true;
      } else {
        Unit.isSignIn = false;
      }
      setState(() {});
    });

    //to get automatic scroll to page view
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChange(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _signIn() async {
    try {
      await AuthProvider().signInWithGoogle();
      setState(
        () {
          Unit.isSignIn = true;
          Get.to(
            HomePage(
              title: Constants.chatty,
            ),
          );
        },
      );
    } catch (e) {
      "Login failed: $e".toToast;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Unit.isSignIn)
        ? HomePage(title: Constants.chatty)
        : Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChange,
                          scrollDirection: Axis.horizontal,
                          itemCount: slideDataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SlideLoginWidget(
                              index: index,
                            );
                          },
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int index = 0;
                                    index < slideDataList.length;
                                    index++)
                                  if (index == _currentPage)
                                    SlideLoginDots(isActive: true)
                                  else
                                    SlideLoginDots(isActive: false)
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(16),
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: _signIn,
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
