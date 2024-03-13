import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:smart_parking/Pages/SignUp.dart';
import 'package:smart_parking/Pages/home.dart';

import '../const.dart';


class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {


  TextEditingController pw = TextEditingController();
  TextEditingController email = TextEditingController();
  bool _obscureText = true;
  bool isLoggedIn=false;
  bool isLoading = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  void checkLoginStatus()  async{
    await Firebase.initializeApp();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      if (user != null) {
        var data = await FirebaseFirestore.instance.collection("User Info").doc(
            FirebaseAuth.instance.currentUser!.uid).get();
        ProfileData.assignData(data);
        setState(() {
          isLoggedIn = true;
        });
      }
    });

  }

  @override
  void initState() {
    checkLoginStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
    Size size = MediaQuery.of(context).size;
    return isLoggedIn?const MyHomePage(): MaterialApp(
      color: Colors.purple,
      title: "StartPage",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Auction"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.purple,
                      Colors.purpleAccent,
                    ])
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text("LOGIN",style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quando",
                    color: Colors.purple,
                  ),),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                    children: <Widget>[
                      Expanded(child:
                      TextField(
                        controller: email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color:Colors.purple,),
                          ),
                          labelText: 'Email ID',
                        ),

                      )
                      ),
                    ]
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                    children: <Widget>[
                      Expanded(child:
                      TextField(
                        obscureText: _obscureText,
                        controller: pw,
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              borderSide: BorderSide(color:Color(0xff8c84c4),),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),

                            ),
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _toggle();
                              },
                              child:
                              Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                            )
                        ),
                      )
                      ),
                    ]
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                LoginButton(
                    text: "Login now",
                    press: () async {
                      if (email.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Enter Email ID",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.purple,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );                      }
                      if (pw.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Enter Email ID",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.purple,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );                         }
                      else {
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        _dialog.show(message: 'PLease Wait');
                        await _auth.signInWithEmailAndPassword(email: email.text, password: pw.text).then((user) async {
                          if(user.user!.emailVerified)  {
                            FirebaseFirestore fireStore = FirebaseFirestore.instance;
                            var data = await fireStore.collection("User Info").doc(_auth.currentUser!.uid).get();
                            ProfileData.assignData(data);
                            _dialog.hide();

                          }
                          else{
                            _dialog.hide();
                            Fluttertoast.showToast(
                                msg: "Please Verify your mail by clicking link sent on mail.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.purple,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );                             }
                        }).catchError((e) {
                          if (kDebugMode) {
                            print(e);
                          }
                          _dialog.hide();
                          Fluttertoast.showToast(
                              msg: "Invalid email or password.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.purple,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );                           });
                      }
                    }
                ),
                TextButton(
                    onPressed: () {
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xff8c84c4)),
                    )),

                Container(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: TextButton(
                      onPressed: () {

                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const Signup()));


                      },
                      child: const Text(
                        "Create An Account",
                        style: TextStyle(color: Color(0xff8c84c4),
                            fontSize: 20
                        ),
                      )),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final void Function()? press;
  final textColor = Colors.white;

  const LoginButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      height: size.height*.08,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          color: Colors.purple,
          child: TextButton(
            onPressed: press,
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
