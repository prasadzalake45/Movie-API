import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'login_screen.dart';
import 'register.dart';
import 'auth.dart';


import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready

  HttpOverrides.global = MyHttpOverrides();
  SharedPreferences prefs=await SharedPreferences.getInstance();
  bool isLoggedIn=prefs.getBool("isLogged")??false;



  runApp(MyApp(startScreen:isLoggedIn?PostPage():Login()));
}


class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp(
    {super.key,
    required this.startScreen,
    });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:startScreen,
    );
  }
}

