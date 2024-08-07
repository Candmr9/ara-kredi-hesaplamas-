import 'package:flutter/material.dart';
import 'package:flutter_application_1/calculator.dart';
import 'package:flutter_application_1/splash.dart';
import 'package:flutter_application_1/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Splash(),
      '/login': (context) => Login(),
      '/calculator': (context) => Calculator(),
    },
  ));
}
