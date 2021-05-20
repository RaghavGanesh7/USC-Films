import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uscfilms/reviews.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Loading extends StatefulWidget {
  @override
  final int id;
  final bool type;
  Loading({Key key, @required this.id, @required this.type}) : super(key: key);
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  int id;
  bool type;
  void initState() {
    id = widget.id;
    type = widget.type;
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
            return Details(id: id, type: type);
          }
        },
        future: Future.delayed(Duration(seconds: 3)),
      ),
    );
  }
}

class Details extends StatefulWidget {
  @override
  final int id;
  final bool type;
  Details({Key key, @required this.id, @required this.type}) : super(key: key);
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int id;
  bool type;
  var title;
  var overview;
  var genres = [];
  var year;
  var castnames = [];
  var castimages = [];
  var reviewtext = [];
  var reviewdates = [];
  var reviewusers = [];
  var ratings = [];
  var recommendations = [];
  var recommendationsimg = [];
  var videolink = "";
  List<dynamic> watchlist = [];
  List<dynamic> typelist = [];
  int index;

  List<Widget> icons = [
    Icon(
      Icons.add_circle_outline_outlined,
      color: Colors.white,
      size: 32,
    ),
    Icon(
      Icons.remove_circle_outline_outlined,
      color: Colors.blue[800],
      size: 32,
    )
  ];
  Future<String> gettitle() async {
    var res1;
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/details/$id"));
    } else {
      res1 =
          await http.get(Uri.parse("http://10.0.2.2:5000/movie/details/$id"));
    }
    var resBody1 = json.decode(res1.body);
    print(resBody1[0]);
    setState(() {
      title = resBody1[0];
    });
  }

  Future<String> getvideo() async {
    var res1;
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/video/$id"));
    } else {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/movie/video/$id"));
    }
    var resBody1 = json.decode(res1.body);
    print(resBody1);
    setState(() {
      videolink = YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=${resBody1[0][3]}");
    });
  }

  Future<String> getoverview() async {
    var res1;
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/details/$id"));
    } else {
      res1 =
          await http.get(Uri.parse("http://10.0.2.2:5000/movie/details/$id"));
    }
    var resBody1 = json.decode(res1.body);
    setState(() {
      overview = resBody1[5];
    });
  }

  Future<String> getgenre() async {
    var res1;
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/details/$id"));
    } else {
      res1 =
          await http.get(Uri.parse("http://10.0.2.2:5000/movie/details/$id"));
    }
    var resBody1 = json.decode(res1.body);
    print(resBody1[1]);
    setState(() {
      for (var item in resBody1[1]) {
        if (item.length != 0) {
          genres.add(item['name']);
        }
      }
    });
  }

  Future<String> getyear() async {
    var res1;
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/details/$id"));
    } else {
      res1 =
          await http.get(Uri.parse("http://10.0.2.2:5000/movie/details/$id"));
    }
    var resBody1 = json.decode(res1.body);
    String y = resBody1[3];
    setState(() {
      year = y.substring(0, 4);
    });
  }

  Future<String> getcast() async {
    var res1;
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/cast/$id"));
    } else {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/movie/cast/$id"));
    }
    var resBody1 = json.decode(res1.body);
    setState(() {
      for (var item in resBody1) {
        if (item.length != 0) {
          if (item[3] != null) {
            castnames.add(item[1]);
            castimages.add(item[3]);
          }
        }
      }
      print(castnames);
    });
  }

  Future<String> getreviews() async {
    var res1;
    print(id);
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/reviews/$id"));
    } else {
      res1 =
          await http.get(Uri.parse("http://10.0.2.2:5000/movie/reviews/$id"));
    }
    var resBody1 = json.decode(res1.body);
    print(resBody1);
    setState(() {
      for (var item in resBody1) {
        if (item.length != 0) {
          reviewtext.add(item[1]);
          reviewusers.add(item[0]);
          var dateFormat = DateFormat("EEEE, MMMd y")
              .format(DateTime.parse(item[2].toString().substring(0, 10)));
          reviewdates.add(dateFormat);
          ratings.add(item[4]);
        }
      }
    });
    print(reviewtext);
  }

  Future<String> getrecommendations() async {
    var res1;
    if (type == false) {
      res1 = await http.get(Uri.parse("http://10.0.2.2:5000/tv/recommend/$id"));
    } else {
      res1 =
          await http.get(Uri.parse("http://10.0.2.2:5000/movie/recommend/$id"));
    }
    var resBody1 = json.decode(res1.body);
    print(resBody1);
    setState(() {
      for (var item in resBody1) {
        if (item.length != 0) {
          recommendations.add(item[0]);
          recommendationsimg.add(item[2]);
        }
      }
    });
  }

  getfunc(String img) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "1";
    final value = id.toString();
    watchlist = prefs.get(key);
    if (watchlist.contains(value)) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: (Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videolink, //Add videoID.
                flags: YoutubePlayerFlags(
                  hideControls: false,
                  controlsVisibleAtStart: true,
                  autoPlay: false,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            ),
            Stack(children: [
              Container(
                width: 400,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.blue[700]),
              ),
              Positioned(
                  bottom: 3,
                  left: 7,
                  child: (title == null)
                      ? Text("")
                      : Wrap(children: [
                          Text(title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "RobotoCondensed",
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1)),
                        ]))
            ]),
            SizedBox(height: 20),
            Text(
              "Overview",
              style: TextStyle(
                  fontFamily: "RobotoCondensed",
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue[800],
                  letterSpacing: -1),
            ),
            ReadMoreText(
              overview,
              trimLines: 4,
              style: TextStyle(fontSize: 18),
              colorClickableText: Colors.grey,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'show more',
              trimExpandedText: 'show less',
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Genres",
              style: TextStyle(
                  fontFamily: "RobotoCondensed",
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue[800],
                  letterSpacing: -1),
            ),
            Container(
              child: SizedBox(
                height: 30,
                width: 380,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return (genres[index] == null)
                        ? Text("")
                        : Text(
                            "${(index == genres.length - 1) ? genres[index] : genres[index] + ','}",
                            style: TextStyle(fontSize: 18),
                          );
                  },
                  itemCount: genres.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            Text("Year",
                style: TextStyle(
                    fontFamily: "RobotoCondensed",
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue[900],
                    letterSpacing: -1)),
            (year == null)
                ? Text("")
                : Text(year,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                children: [
                  TextButton(
                      child: FutureBuilder(
                          future: getfunc(id.toString()),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text('Press button to start.');
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return Text('');
                              case ConnectionState.done:
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');

                                return icons[snapshot.data];
                            }
                            return null;
                          }),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final key = "1";
                        final key1 = "2";
                        final value = id.toString();
                        final value1 = type.toString();
                        watchlist = prefs.getStringList(key);
                        typelist = prefs.getStringList(key1);
                        print(watchlist);
                        print(typelist);
                        if (watchlist.contains(id.toString())) {
                          watchlist.remove(value);
                          typelist.remove(value1);
                          prefs.setStringList(key, watchlist);
                          prefs.setStringList(key1, typelist);
                          print("Remove");
                          setState(() {
                            Toast.show(
                                "$title was removed from the list", context,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            index = 1;
                          });
                        } else {
                          watchlist.add(value);
                          typelist.add(value1);
                          prefs.setStringList(key, watchlist);
                          prefs.setStringList(key1, typelist);
                          print('saved $value');
                          setState(() {
                            Toast.show("$title was added to the list", context,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            index = 0;
                          });
                        }
                      }),
                  TextButton(
                    onPressed: () async {
                      await canLaunch(
                              "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/${id.toString()}")
                          ? await launch(
                              "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/${id.toString()}")
                          : throw 'Could not launch https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/${id.toString()}';
                    },
                    child: FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue[800],
                      size: 32,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      SocialShare.shareTwitter("",
                          url:
                              "https://www.themoviedb.org/movie/${id.toString()}");
                    },
                    child: FaIcon(
                      FontAwesomeIcons.twitter,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            Text("Cast",
                style: TextStyle(
                    fontFamily: "RobotoCondensed",
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue[800],
                    letterSpacing: -1)),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 320, minHeight: 50),
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 25),
                  itemCount: castimages.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/${castimages[index]}"),
                          )),
                      Positioned(
                          bottom: -32,
                          left: (castnames[index].toString().length < 13)
                              ? 32
                              : 23,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: 100,
                            height: 50,
                            child: (castnames[index] == null)
                                ? Text("None")
                                : Text(
                                    castnames[index],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                  ),
                          )),
                    ]);
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            (reviewtext.length == 0)
                ? Text("")
                : Text(
                    "Reviews",
                    style: TextStyle(
                        fontFamily: "RobotoCondensed",
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue[800],
                        letterSpacing: -1),
                  ),
            (reviewtext.length == 0)
                ? Text("")
                : ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 370, minHeight: 50),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return (reviewtext[index] == null)
                              ? Text("None")
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Reviews(id: id, index: index);
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "by ${reviewusers[index]} on ${reviewdates[index]}",
                                          style: TextStyle(
                                              fontFamily: "RobotoCondensed",
                                              fontSize: 21,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.blue[800],
                                              letterSpacing: -1),
                                        ),
                                        (ratings[index] == null)
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "0/10",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Icon(Icons.star,
                                                      size: 20,
                                                      color: Colors.yellow[400])
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    "${ratings[index].toString()}/10",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Icon(Icons.star,
                                                      size: 20,
                                                      color: Colors.yellow[400])
                                                ],
                                              ),
                                        Text(
                                          reviewtext[index],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        },
                        itemCount:
                            (reviewtext.length >= 3) ? 3 : reviewtext.length),
                  ),
            Text(
              "Recommendations",
              style: TextStyle(
                  fontFamily: "RobotoCondensed",
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue[800],
                  letterSpacing: -1),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                child: SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: recommendationsimg.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Details(id: recommendations[index], type: type);
                      }));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                      width: 120,
                      height: 160,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w500/${recommendationsimg[index]}"),
                              alignment: Alignment.center,
                              fit: BoxFit.fitWidth)),
                    ),
                  );
                },
              ),
            )),
            SizedBox(
              height: 30,
            )
          ],
        )),
      ),
    ));
  }

  void initState() {
    super.initState();
    id = widget.id;
    type = widget.type;
    // this.getvideo();
    this.gettitle();
    this.getoverview();
    this.getgenre();
    this.getyear();
    this.getcast();
    this.getreviews();
    this.getrecommendations();
  }

  void dispose() {
    super.dispose();
  }
}
