import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:api_in/data/data_sources/auth_remote_data_source.dart';
import 'package:api_in/data/repositories/auth_repository_impl.dart';
import 'package:api_in/domain/repositories/auth_repository.dart';
import 'package:api_in/presentation/pages/register_page.dart';
import 'package:api_in/presentation/pages/login_page.dart';
import 'package:api_in/presentation/state_mangement/register_provider.dart';
import 'package:api_in/presentation/state_mangement/login_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  final authRepository = AuthRepositoryImpl(AuthRemoteDataSource());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => LoginProvider(authRepository)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(), // Start from Login Page
    );
  }
}
