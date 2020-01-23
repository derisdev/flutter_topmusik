import 'package:flutter/material.dart';
import 'package:topmusik/model/song.dart';
import 'package:topmusik/ui/player.dart';

class Search extends StatefulWidget {
  final List<Song> song;
  Search({Key key, @required this.song}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController editingController = TextEditingController();
  
  List<Song> song = List<Song>();


  @override
  void initState() { 
    super.initState();
    this.song.clear();
  }

  void filterSearchResult(String query) async {
    query = query.toLowerCase();

    if (query.isNotEmpty) {
      List<Song> listData = List<Song>();

      widget.song.forEach((item) {
        if (item.title.toLowerCase().contains(query) ||
            item.artist.toLowerCase().contains(query)) {
          listData.add(item);
        }
      });
        setState(() {
          song.clear();
          song.addAll(listData);
        });
      return;
    } else {
        setState(() {
          song.clear();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/backgroundplayer.jpeg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Container(
                    width: 280,
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.pink,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      controller: editingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Cari Lagu..',
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontFamily: 'neue'),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.7)))),
                      onChanged: (value) {
                        filterSearchResult(value);
                      },
                    ),
                  ),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.2),
      ),
      itemCount: song.length == null ? 0 : song.length,
      itemBuilder: (BuildContext context, int index) {
        final a = song[index];
        return InkWell(
          splashColor: Colors.grey,
          onTap: (){
            Navigator.pop(context);
          Navigator.push(context,
                MaterialPageRoute(builder: (context) => Player(song: widget.song, index: index,)));
          },
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
    ),
        )
      ],
    );
  }
}
