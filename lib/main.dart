import 'package:ffs/auth//stub.dart'
    if (dart.library.io) 'package:ffs/auth/android_auth_provider.dart'
    if (dart.library.html) 'package:ffs/auth/web_auth_provider.dart';
import 'package:ffs/ui/home/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthProvider().initializes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        title: "Chatty",
      ),
    );
  }
}
