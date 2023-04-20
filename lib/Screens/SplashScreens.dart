import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phonebook/Screens/HomePage.dart';
import 'package:phonebook/Screens/LoginScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreens extends StatefulWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  void resetNewLaunch() async {
    Timer(Duration(seconds: 3), () async {
      if (!mounted) return;
      SharedPreferences _prefs =
      await SharedPreferences.getInstance();
      if(_prefs.containsKey("name")){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>  HomePage()));
      }
      else
      {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>  LoginScreens()));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    resetNewLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/phone-book.png",
          width: 60.0,height: 60.0,)),
        ],
      ),
    );
  }
}
