
import 'package:flutter/material.dart';
import 'package:smart_parking/Paint/CustomPaintHome.dart';
import 'package:smart_parking/Transitions/FadeTransition.dart';
import 'package:smart_parking/Widget/recents.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          TopBar_home(),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.menu,
                      color: Colors.white.withOpacity(0.9),
                      size: 26,
                    ),
                  ),
                  title: const Center(
                    child: Text(
                      'Quick Park',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quickstand'
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white.withOpacity(0.9),
                        size: 24,
                      ),
                    )
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28,top: 40,right: 28,bottom: 10),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      title: TextField(
                        enabled: false,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Where do you go?',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            letterSpacing: 0.2
                          )
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: (){
                        },
                        child: Icon(
                            Icons.search,
                          size: 27,
                          color: Colors.orange[400],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Recents(),
            ],
          )
        ],
      ),
    );
  }
}
