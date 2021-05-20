import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:uscfilms/details.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  List type = [];
  List image = [];
  List<String> id = [];
  List<String> id1 = [];
  ScrollController _scrollController;
  List<String> imgs = [];
  List<String> tits = [];

  void initState() {
    setState(() {
      this.loadList();
    });
    super.initState();
    print(id);
  }

  FutureOr back(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (id.length == 0)
        ? Center(child: Text("Nothing saved to Watchlist"))
        : DragAndDropGridView(
            controller: _scrollController,
            onReorder: (oldindex, newindex) async {
              final prefs = await SharedPreferences.getInstance();
              final key = "1";
              final key1 = "2";
              var value = prefs.getStringList(key);
              var value1 = prefs.getStringList(key1);
              print(value);
              print(value1);
              var temp1 = value[newindex];
              value[newindex] = value[oldindex];
              value[oldindex] = temp1;
              var temp2 = value1[newindex];
              value1[newindex] = value1[oldindex];
              value1[oldindex] = temp2;
              var temp = id[newindex];
              id[newindex] = id[oldindex];
              id[oldindex] = temp;
              print(value);
              print(value1);
              setState(() {
                imgs = value;
                tits = value1;
                prefs.setStringList(key, value);
                prefs.setStringList(key1, value1);
              });
            },
            onWillAccept: (oldIndex, newIndex) => true,
            itemCount: id.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 20),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Loading(
                        id: int.parse(imgs[index]),
                        type: tits[index] == 'true');
                  })).then(back);
                },
                child: GridTile(
                  child: Stack(children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      width: 120,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w500/${id[index]}"),
                              alignment: Alignment.center,
                              fit: BoxFit.fitWidth)),
                    ),
                    Positioned(
                        bottom: 0,
                        right: -10,
                        child: TextButton(
                          child: Icon(Icons.remove_circle_outline_outlined),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final key = "1";
                            final key1 = "2";
                            var value = prefs.getStringList(key);
                            var value1 = prefs.getStringList(key1);
                            setState(() {
                              value.removeAt(index);
                              value1.removeAt(index);
                              id.removeAt(index);
                              id1.removeAt(index);
                              prefs.setStringList(key, value);
                              prefs.setStringList(key1, value1);
                            });
                            print(value);
                          },
                        )),
                    Positioned(
                        bottom: 10,
                        left: 26,
                        child: Text(
                          "${id1[index]}",
                        ))
                  ]),
                ),
              );
            },
          );
  }

  void getsomething(List<dynamic> images, List<dynamic> titles) async {
    var res1;
    for (var i = 0; i < titles.length; i++) {
      print(titles[i]);
      print('lOl ${images[i]}');
      if (titles[i] == 'false') {
        res1 = await http
            .get(Uri.parse("http://10.0.2.2:5000/tv/details/${images[i]}"));
        var resBody1 = json.decode(res1.body);
        print("inside tv $resBody1");
        setState(() {
          id1.add("TV");
          id.add(resBody1[8]);
        });
      } else {
        res1 = await http
            .get(Uri.parse("http://10.0.2.2:5000/movie/details/${images[i]}"));
        var resBody1 = json.decode(res1.body);
        print(" inside movie $resBody1");
        setState(() {
          id1.add("Movie");
          id.add(resBody1[8]);
        });
      }
    }
  }

  void loadList() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "1";
    final key1 = "2";
    final value = prefs.getStringList(key);
    final value1 = prefs.getStringList(key1);
    setState(() {
      imgs = value;
      tits = value1;
    });
    print("id :$value");
    print("type: $value1");
    getsomething(value, value1);
  }
}
