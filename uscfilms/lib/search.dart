import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uscfilms/details.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List img = [], names = [], year = [], votes = [], type = [], ids = [];
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xff1f2c3b),
        body: Stack(children: [
          AppBar(
            backgroundColor: Color(0xff1f2c3b),
            title: TextField(
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: "Search Movies and TV Shows"),
              autofocus: true,
              onChanged: (text) {
                somefunction(text);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
            alignment: Alignment.center,
            child: SizedBox(
              width: 390,
              child: ListView.builder(
                itemCount: img.length,
                itemBuilder: (context, index) {
                  return (img == [])
                      ? Center(
                          child: Text("No results found."),
                        )
                      : Stack(children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Details(
                                      id: ids[index],
                                      type: (type[index] == 'movie')
                                          ? true
                                          : false);
                                }));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 170,
                                    width: 380,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(1)),
                                        ],
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://image.tmdb.org/t/p/w500/${img[index]}"),
                                            fit: BoxFit.cover)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 20,
                              left: 10,
                              child: Text(
                                names[index],
                                style: TextStyle(fontSize: 20),
                              )),
                          Positioned(
                            child: Text(
                              "${type[index].toString().toUpperCase()}(${year[index].toString().substring(0, 4)})",
                              style: TextStyle(fontSize: 15),
                            ),
                            top: 15,
                            left: 10,
                          ),
                          Positioned(
                              top: 20,
                              right: 20,
                              child: Text(
                                votes[index].toString(),
                                style: TextStyle(fontSize: 15),
                              )),
                          Positioned(
                              top: 16,
                              right: 40,
                              child: Icon(Icons.star,
                                  size: 25, color: Colors.yellow[400]))
                        ]);
                },
              ),
            ),
          )
        ]));
  }

  void somefunction(text) async {
    if (text == '') {
      setState(() {
        ids = [];
        img = [];
        names = [];
        year = [];
        votes = [];
        type = [];
      });
    } else {
      String uri = "http://10.0.2.2:5000/$text";
      var res = await http.get(Uri.parse(uri));
      var resBody = json.decode(res.body);
      List images = [],
          titles = [],
          dates = [],
          ratings = [],
          media = [],
          id = [];
      print(resBody);
      for (var item in resBody) {
        if (item.length != 0) {
          if (item[1] != null) {
            id.add(item[0]);
            images.add(item[1]);
            titles.add(item[3]);
            dates.add(item[5]);
            ratings.add(item[4]);
            media.add(item[2]);
          }
        }
      }
      setState(() {
        ids = id;
        img = images;
        names = titles;
        year = dates;
        votes = ratings;
        type = media;
      });
    }
  }
}
