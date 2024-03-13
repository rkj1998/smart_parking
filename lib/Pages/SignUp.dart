import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:smart_parking/Pages/StartPage.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {


  TextEditingController pw = TextEditingController();
  TextEditingController cpw = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController email = TextEditingController();

  String gender = 'Select Gender';
  bool _obscureText = true;
  bool _obscureText2 = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }
  DateTime date = DateTime.now();
  Future<void> _date(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
    return MaterialApp(
      color: Colors.lightBlueAccent,
      title: "Sign Up",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Sign up"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.lightBlueAccent,
                      Colors.greenAccent,
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
                const SizedBox(height: 10,),
                Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: fName,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color:Colors.lightBlueAccent,),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          labelText: 'First Name',
                        ),
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: lName,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color:Colors.lightBlueAccent,),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          labelText: 'Last Name',
                        ),
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_downward),
                              underline: const SizedBox(),
                              value: gender,
                              onChanged: (String? newValue) {
                                setState(() {
                                  gender = newValue!;
                                });
                              },
                              items: <String>[
                                'Select Gender',
                                'Male',
                                'Female',
                                'Others'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        height: 60,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Text("Select Birthday : "),
                            Expanded(
                              child: Text(
                                  DateFormat('dd-MM-yyyy').format(date).toString()),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _date(context);
                      },
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: email,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color:Colors.lightBlueAccent,),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          labelText: 'Email Address',
                        ),
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),

                Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: mob,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color:Colors.lightBlueAccent,),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          labelText: 'Mobile Number',
                        ),
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),

                Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        obscureText: _obscureText,
                        controller: pw,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _toggle,
                          ),
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
                        ),
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        obscureText: _obscureText2,
                        controller: cpw,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _toggle2,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color:Color(0xff8c84c4),),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          labelText: 'Confirm Password',
                        ),
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () async {
                      String formattedDate = DateFormat('dd-MM-yyyy').format(date);
                      if(fName.text.isEmpty||RegExp(r'[.!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(fName.text)==true){
                        Fluttertoast.showToast(
                            msg: "Please Enter A Proper First Name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else if(lName.text.isEmpty||RegExp(r'[.!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(lName.text)==true){
                        Fluttertoast.showToast(
                            msg: "Please Enter A Proper Last Name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );                      }
                      else if(gender == 'Select Gender'){
                        Fluttertoast.showToast(
                            msg: "Please Select A Gender",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );                      }
                      else if(email.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "Please Enter A Proper EMail",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );                      }


                      else if(pw.text.isEmpty||pw.text.length<6||RegExp(r'[A-Z]').hasMatch(pw.text)==false||RegExp(r'[a-z]').hasMatch(pw.text)==false||RegExp(r'[0-9]').hasMatch(pw.text)==false||RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pw.text)==false){
                        Fluttertoast.showToast(
                            msg: "Password cannot be less than 6 digits and must contain an alphabet,number and a special character.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else if(pw.text!=cpw.text){
                        Fluttertoast.showToast(
                            msg: "Passwords Don't Match",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else{
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        User? user;
                        final CollectionReference userData = FirebaseFirestore.instance.collection(
                            'User Info');
                        try{
                          _dialog.show(message: "Please Wait");
                          user =
                              (await _auth.createUserWithEmailAndPassword(
                                  email: email.text, password: pw.text))
                                  .user;
                          await user?.sendEmailVerification();

                          await userData.doc(user?.uid).set({
                            "FirstName":fName.text,
                            "LastName":lName.text,
                            "Gender":gender,
                            "DOB":formattedDate,
                            "Email":email.text,
                            "Mobile":mob.text,
                            "ProfPic":"https://firebasestorage.googleapis.com/v0/b/hpc-enterprises.appspot.com/o/initial.png?alt=media&token=022c3fe6-cb2b-456f-8985-94b77c3a4c21",
                            "Balance":0,
                          });
                          Fluttertoast.showToast(
                              msg: "A verification mail has been sent please verify to start using the application.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.purple,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          _dialog.hide();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const StartPage()),(Route<dynamic> route) => false);
                        }
                        catch(e){
                          _dialog.hide();
                          Fluttertoast.showToast(
                              msg: e.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.purple,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }

                      }

                    },
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40.0),
                          ),
                          color: Colors.lightBlueAccent,
                        ),
                        margin: const EdgeInsets.all(10.0),
                        child: const Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
