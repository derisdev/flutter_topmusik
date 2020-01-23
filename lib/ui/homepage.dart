import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:topmusik/model/song.dart';
import 'package:topmusik/ui/player.dart';
import 'package:topmusik/ui/search.dart';
import 'package:topmusik/ui/widget/drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Song> song = [];

  @override
  void initState() {
    super.initState();
    fetchJson();
  }

  fetchJson() async {
    final response = await rootBundle.loadString('datajson/data.json');
    final data = jsonDecode(response);

    if (mounted) {
      setState(() {
    for (Map i in data) {
      song.add(Song.fromJson(i));
    }
    song.sort((a, b)=> a.title.compareTo(b.title));
  });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/background.jpeg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
            appBar: AppBar(
              title: Text('BTS'),
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                Padding(
                      padding: const EdgeInsets.only(right :10.0),
                      child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Search(song: song,)
                            ));
                          },
                        ),
                    )
              ],
              elevation: 0.0,
            ),
            backgroundColor: Colors.transparent,
            drawer: DrawerHome(),
            body: song.isNotEmpty
                ? ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.2),
        height: 20,
      ),
      itemCount: song.length == null ? 0 : song.length,
      itemBuilder: (BuildContext context, int index) {
        final a = song[index];
        return InkWell(
          splashColor: Colors.grey,
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Player(song: song, index: index,)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          a.title,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              fontFamily: 'neue'),
                        ),
                        Text(a.artist.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                                fontFamily: 'neue')),
                      ],
                    ),
                    Text(
                      a.time,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                          fontFamily: 'neue'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    )
                : Center(
                    child: SpinKitThreeBounce(
                      color: Color(0xffec2f82),
                      size: 50.0,
                    )
                  ))
      ],
    );
  }
}
