import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

import 'dart:convert';

class Loading2 extends StatefulWidget {
  @override
  final int id;
  final int index;
  Loading2({Key key, @required this.id, @required this.index})
      : super(key: key);
  _Loading2State createState() => _Loading2State();
}

class _Loading2State extends State<Loading2> {
  int id;
  int index;
  void initState() {
    id = widget.id;
    index = widget.index;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
            return Reviews(id: id, index: index);
          }
        },
        future: Future.delayed(Duration(seconds: 3)),
      ),
    );
  }
}

class Reviews extends StatefulWidget {
  @override
  final int id;
  final int index;
  Reviews({Key key, @required this.id, @required this.index}) : super(key: key);
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  var reviewtext = [];
  var reviewdates = [];
  var reviewusers = [];
  String text;
  String date;
  String user;
  var ratings = [];
  var something;
  int id;
  int ind;
  @override
  Future<String> getrev() async {
    var res1 =
        await http.get(Uri.parse("http://10.0.2.2:5000/movie/reviews/$id"));
    var resBody1 = json.decode(res1.body);
    print(resBody1);
    setState(() {
      for (var item in resBody1) {
        reviewtext.add(item[1]);
        reviewusers.add(item[0]);
        var dateFormat = DateFormat("EEEE, MMMd y")
            .format(DateTime.parse(item[2].toString().substring(0, 10)));
        reviewdates.add(dateFormat);
        ratings.add(item[4]);
      }
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
          Text("Reviews"),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (ratings[ind] == null)
                  ? Row(
                      children: [
                        Text(
                          "0/10",
                          style: TextStyle(fontSize: 25),
                        ),
                        Icon(Icons.star, size: 30, color: Colors.yellow[400])
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          "${ratings[ind].toString()}/10",
                          style: TextStyle(fontSize: 25),
                        ),
                        Icon(Icons.star, size: 30, color: Colors.yellow[400])
                      ],
                    ),
              Text("by ${reviewusers[ind]} on ${reviewdates[ind]}",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w900)),
              SizedBox(
                height: 20,
              ),
              Text(
                reviewtext[ind],
                style: TextStyle(fontSize: 18),
              )
            ],
          ))
        ]),
      )),
    );
  }

  void initState() {
    super.initState();
    id = widget.id;
    ind = widget.index;
    this.getrev();
  }

  void dispose() {
    super.dispose();
  }
}
