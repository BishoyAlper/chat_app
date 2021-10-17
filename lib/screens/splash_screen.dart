import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text("Loading...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}