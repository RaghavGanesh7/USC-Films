import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:uscfilms/details.dart';

class Popular extends StatefulWidget {
  @override
  final bool type;
  Popular({Key key, @required this.type}) : super(key: key);
  _PopularState createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  @override
  bool type;
  String id;
  String uri;
  String img1, img2, img3, img4, img5, img6, img7, img8, img9, img10;
  int id1, id2, id3, id4, id5, id6, id7, id8, id9, id10;
  String title1,
      title2,
      title3,
      title4,
      title5,
      title6,
      title7,
      title8,
      title9,
      title10;
  List popup = ['tmdb', 'fb', 'twt', 'watchlist'];
  List<dynamic> watclist = [];
  List<dynamic> titlelist = [];
  String addremove = "";
  Future<String> getdata() async {
    if (type == true) {
      uri = "http://10.0.2.2:5000/movie/popular";
    } else {
      uri = "http://10.0.2.2:5000/tv/popular";
    }
    var res = await http.get(Uri.parse(uri));
    var resBody = json.decode(res.body);
    setState(() {
      img1 = resBody[0][2];
      img2 = resBody[1][2];
      img3 = resBody[2][2];
      img4 = resBody[3][2];
      img5 = resBody[4][2];
      img6 = resBody[5][2];
      img7 = resBody[6][2];
      img8 = resBody[7][2];
      img9 = resBody[8][2];
      img10 = resBody[9][2];
      id1 = resBody[0][0];
      id2 = resBody[1][0];
      id3 = resBody[2][0];
      id4 = resBody[3][0];
      id5 = resBody[4][0];
      id6 = resBody[5][0];
      id7 = resBody[6][0];
      id8 = resBody[7][0];
      id9 = resBody[8][0];
      id10 = resBody[9][0];
      title1 = resBody[0][1];
      title2 = resBody[1][1];
      title3 = resBody[2][1];
      title4 = resBody[3][1];
      title5 = resBody[4][1];
      title6 = resBody[5][1];
      title7 = resBody[6][1];
      title8 = resBody[7][1];
      title9 = resBody[8][1];
      title10 = resBody[9][1];
    });
  }

  getfunc(String img) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "1";
    final value = img.toString();
    watclist = prefs.get(key);
    if (watclist.contains(value)) {
      return "Remove from watchlist";
    } else {
      return "Add to Watchlist";
    }
  }

  somefunction(int choice, String id, String actualid, String tit) async {
    if (choice == 4) {
      final prefs = await SharedPreferences.getInstance();
      final key = "1";
      final key1 = "2";
      final value = actualid;
      watclist = prefs.getStringList(key);
      titlelist = prefs.getStringList(key1);
      print(watclist);
      print(titlelist);
      if (watclist.contains(actualid.toString())) {
        int index = watclist.indexOf(actualid.toString());
        print(index);
        print(watclist);
        watclist.remove(actualid.toString());
        titlelist.removeAt(index);
        prefs.setStringList(key, watclist);
        prefs.setStringList(key1, titlelist);
        print("Remove");
        setState(() {
          Toast.show("$tit was removed from the list", context,
              textColor: Colors.black,
              backgroundColor: Colors.white,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM);
          addremove = "Add to Watchlist";
        });
      } else {
        print('id ::::$actualid');
        watclist.add(actualid.toString());
        titlelist.add(type.toString());
        prefs.setStringList(key, watclist);
        prefs.setStringList(key1, titlelist);
        print('saved $value');
        print('saved $titlelist');
        setState(() {
          Toast.show("$tit was added to the list", context,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM);
          addremove = "Remove from Watchlist";
        });
      }
    }
    if (choice == 1) {
      await canLaunch("https://www.themoviedb.org/movie/$actualid")
          ? await launch("https://www.themoviedb.org/movie/$actualid")
          : throw 'Could not launch https://www.themoviedb.org/movie/$actualid';
    }
    if (choice == 3) {
      SocialShare.shareTwitter("",
          url: "https://www.themoviedb.org/movie/$actualid");
    }
    if (choice == 2) {
      await canLaunch(
              "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/$actualid")
          ? await launch(
              "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/$actualid")
          : throw 'Could not launch https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/$actualid';
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id1, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img1"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img1, id1.toString(), title1);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id1.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id2, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img2"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img2, id2.toString(), title1);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id2.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id3, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img3"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img3, id3.toString(), title3);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id3.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id4, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img4"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img4, id4.toString(), title4);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id4.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id5, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img5"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img5, id5.toString(), title5);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id5.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id6, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img6"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img6, id6.toString(), title6);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id6.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id7, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img7"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img7, id7.toString(), title7);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id7.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id8, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img8"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img8, id8.toString(), title8);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id8.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id9, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img9"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img9, id9.toString(), title9);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id9.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Loading(id: id10, type: type);
              }));
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                width: 120,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/$img10"),
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth)),
              ),
              Positioned(
                  right: 0,
                  bottom: 10,
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (choice) {
                      somefunction(choice, img10, id10.toString(), title10);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Open in TMDB",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Share on Facebook",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Share on Twitter",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                          value: 4,
                          child: FutureBuilder(
                              future: getfunc(id10.toString()),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');

                                    return Text('${snapshot.data}',
                                        style: TextStyle(color: Colors.black));
                                }
                                return null;
                              }))
                    ],
                  ))
            ]),
          ),
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    this.type = widget.type;
    this.getdata();
  }
}
