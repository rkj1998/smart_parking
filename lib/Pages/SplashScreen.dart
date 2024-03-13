import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/Pages/StartPage.dart';
import 'package:smart_parking/Pages/home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            _getLandingPage(),
      ));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/logo.png',
                fit: BoxFit.contain,),
            ),
          ],

        ),
      ),
    );
  }
}

Widget _getLandingPage()  {
  bool userVerified = false;
  verify() async {
    var user =  FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      userVerified= true;
      if (kDebugMode) {
        print("True");
      }
    }
    else{
      userVerified = false;
      if (kDebugMode) {
        print("false");
      }
    }
  }

  return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        verify();
        if (snapshot.hasData) {
          if (userVerified == true) {}
          else if (userVerified == false) {}
          else {
            return const StartPage();
          }
        }
        return const StartPage();
      }

  );
}