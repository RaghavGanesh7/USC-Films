import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:uscfilms/home.dart';
import 'package:uscfilms/search.dart';
import 'package:uscfilms/watchlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          accentColor: Colors.white,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: Future.delayed(Duration(seconds: 4)),
            builder: (context, AsyncSnapshot snapshot) {
              // Show splash screen while waiting for app resources to load:
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: Center(
                    child: Image.asset(
                      "lib/assets/vector.png",
                      width: 80,
                      height: 80,
                    ),
                  ),
                  color: Color(0xff1f2c3b),
                );
              } else {
                // Loading is done, return the app:
                return Loading1();
              }
            }));
  }
}

class Loading1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff1f2c3b),
        body: FutureBuilder(
            future: Future.delayed(Duration(seconds: 3)),
            builder: (context, AsyncSnapshot snapshot) {
              // Show splash screen while waiting for app resources to load:
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitRing(color: Colors.blue[800]),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Loading")
                  ],
                );
              } else {
                // Loading is done, return the app:
                return Home(
                  type: true,
                );
              }
            }));
  }
}
