import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uscfilms/main.dart';
import 'package:uscfilms/popular.dart';
import 'package:uscfilms/search.dart';
import 'package:uscfilms/watchlist.dart';
import 'imageslider.dart';
import 'toprated.dart';

class Home extends StatefulWidget {
  @override
  final bool type;
  Home({Key key, @required this.type}) : super(key: key);
  _HomeState createState() => _HomeState();
}

Color movie = Colors.white;
Color tv = Colors.blueAccent[300];

class _HomeState extends State<Home> {
  @override
  bool type = true;
  int currentIndex = 0;
  List<Widget> children = [Home(type: true), Search(), Watchlist()];
  void onTapped(int index) {
    setState(() {
      print(currentIndex);
      currentIndex = index;
    });
  }

  void initState() {
    type = widget.type;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff1f2c3b),
          onTap: onTapped,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: (currentIndex == 0) ? Colors.white : Colors.blue[800],
                ),
                label: "Home",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color:
                        (currentIndex == 1) ? Colors.white : Colors.blue[800]),
                label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time,
                    color:
                        (currentIndex == 2) ? Colors.white : Colors.blue[800]),
                label: "Watchlist"),
          ],
        ),
        backgroundColor: Color(0xff1f2c3b),
        body: (currentIndex == 0)
            ? SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Row(
                      children: [
                        Image.asset(
                          "lib/assets/vector.png",
                          width: 50,
                          height: 50,
                        ),
                        Text(
                          "USC Films",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                movie = Colors.white;
                                tv = Colors.blueAccent[300];
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Home(type: true);
                              }));
                            },
                            child: Text(
                              "Movies",
                              style: TextStyle(color: movie, fontSize: 15),
                            )),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                movie = Colors.blueAccent[300];
                                tv = Colors.white;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Home(type: false);
                              }));
                            },
                            child: Text(
                              "TV Shows",
                              style: TextStyle(color: tv, fontSize: 15),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ImageSlider(type: type),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text("Top-Rated",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Heebo',
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TopRated(
                    type: type,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text("Popular",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Heebo',
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Popular(
                    type: type,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(120, 20, 0, 0),
                      child: GestureDetector(
                        onTap: () async {
                          await canLaunch("https://themoviedb.org")
                              ? await launch("https://themoviedb.org")
                              : throw 'Could not launch';
                        },
                        child: Column(children: [
                          Text(
                            "Powered by TMDB",
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                          Text("Developed by Raghav Ganesh",
                              style: TextStyle(color: Colors.blue[800])),
                        ]),
                      )),
                ],
              ))
            : children[currentIndex]);
  }
}
