import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  @override
  final bool type;
  ImageSlider({Key key, @required this.type}) : super(key: key);
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  bool type;
  String uri;
  int current;
  String img1, img2, img3, img4, img5;
  List images = [];
  Future<String> getdata() async {
    if (type == true) {
      uri = "http://10.0.2.2:5000/movie/trending";
    } else {
      uri = "http://10.0.2.2:5000/tv/trending";
    }
    print(type);
    print(uri);
    var res = await http.get(Uri.parse(uri));
    var resBody = json.decode(res.body);
    setState(() {
      img1 = resBody[0][2];
      img2 = resBody[1][2];
      img3 = resBody[2][2];
      img4 = resBody[3][2];
      img5 = resBody[4][2];
      images = [img1, img2, img3, img4, img5];
      print(images);
    });
  }

  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 900,
      child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            CarouselSlider(
                items: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/$img1",
                              ),
                              alignment: Alignment.center,
                              fit: BoxFit.contain)),
                    ),
                  ]),
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/$img2"),
                            alignment: Alignment.center,
                            fit: BoxFit.contain)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/$img3"),
                            alignment: Alignment.center,
                            fit: BoxFit.contain)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/$img4"),
                            alignment: Alignment.center,
                            fit: BoxFit.contain)),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/$img5"),
                            alignment: Alignment.center,
                            fit: BoxFit.contain)),
                  )
                ],
                options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 1,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        current = index;
                      });
                    },
                    autoPlayAnimationDuration: Duration(milliseconds: 600))),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (current == 0) ? Colors.blue[800] : Colors.white,
                ),
              ),
              Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (current == 1) ? Colors.blue[800] : Colors.white,
                ),
              ),
              Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (current == 2) ? Colors.blue[800] : Colors.white,
                ),
              ),
              Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (current == 3) ? Colors.blue[800] : Colors.white,
                ),
              ),
              Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (current == 4) ? Colors.blue[800] : Colors.white,
                ),
              ),
            ]),
          ]),
    );
  }

  void initState() {
    super.initState();
    this.type = widget.type;
    this.getdata();
    images = [img1, img2, img3, img4, img5];
  }
}
