import 'package:flutter/material.dart';
import 'dart:async'; // dart:async paketini ekleyin

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer(); // starTimer değil startTimer olmalı
  }

  void startTimer() {
    var duration = Duration(seconds: 4);
    Timer(duration, route); // Timer tanımlandı
  }

  void route() {
    Navigator.of(context).pushNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Image.asset("assets/car.jpg"),
        ),
        Text(
          "Araç Kredisi Hesaplama",
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
