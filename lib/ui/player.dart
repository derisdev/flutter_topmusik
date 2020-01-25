import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:topmusik/model/song.dart';
import 'package:topmusik/ui/widget/pageview.dart';


const String testDevice = '956ABAFBFBD24ACFE9545C682ECED541';

class Player extends StatefulWidget {
  final List<Song> song;
  final int index;
  Player({Key key, @required this.song, this.index}) : super(key: key);
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice!=null? <String>[testDevice] : null,
    nonPersonalizedAds: false,
    keywords: <String>['music','karaoke']
  );

  InterstitialAd myInterstitial = InterstitialAd(
  adUnitId: "ca-app-pub-5874836034807105/8432693401",
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);




  bool playing = true;

  final PageController controller = new PageController();

  Duration duration = new Duration();
  Duration position = new Duration();
  AudioPlayer audioPlayer;
  AudioPlayerState playerState;


  Song currentSong = new Song();
  int currentIndex = 0;



  @override
  void initState() {
    super.initState();

    myInterstitial
  ..load()
  ..show(
    anchorType: AnchorType.bottom,
    anchorOffset: 0.0,
    horizontalCenterOffset: 0.0,
  );



    currentSong = widget.song[widget.index];
    currentIndex = widget.index;
    initPlayer();
    playAudio();
  }


  void initPlayer() {
     audioPlayer = AudioPlayer();

     if (audioPlayer != null) {
      stopAudio();
      playerState = AudioPlayerState.PLAYING;

    }
      playerState = AudioPlayerState.PLAYING;

    audioPlayer.onAudioPositionChanged
        .listen((p){
           if(mounted){
             setState(() => position = p);
           }
        });
         
    audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        if(mounted){
          setState(() {
          duration = audioPlayer.duration;
        });
        }
      } else if (s == AudioPlayerState.STOPPED) {
        if(mounted){
          setState(() {
          position = duration;
        });
        }
        if (duration.inSeconds.toDouble()>0) {
          nextSong();
        }
      }
    }, onError: (msg) {
     if(mounted){
        setState(() {
        playerState = AudioPlayerState.STOPPED;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
     }
    });
  }


  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration.inSeconds.toDouble());
  }

  void nextSong() {
  
    stopAudio();
    if (currentIndex < widget.song.length-1) {
      if(mounted){
        setState(() {
      currentSong = widget.song[currentIndex+1]; 
      currentIndex++;
      duration = Duration(seconds: 0);
      position = Duration(seconds: 0);
      });
      }
    }
    else {
      if(mounted){
        setState(() {
      currentSong = widget.song[0]; 
      currentIndex = 0;
      duration = Duration(seconds: 0);
      position = Duration(seconds: 0);
      });
      }
    }
    playAudio();

  }
  void prevSong() {

    stopAudio();
    if (currentIndex > 0) {
      if(mounted){
        setState(() {
      currentSong = widget.song[currentIndex-1]; 
      currentIndex--;
      duration = Duration(seconds: 0);
      position = Duration(seconds: 0);
      });
      }
    }
    else {
      if(mounted){
        setState(() {
      currentSong = widget.song[widget.song.length-1]; 
      currentIndex = widget.song.length-1;
      duration = Duration(seconds: 0);
      position = Duration(seconds: 0);
      });
      }
    }
    playAudio();
  }

  @override
  void dispose() {
    myInterstitial.dispose();
    super.dispose();
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
            title: Text(
              currentSong.title,
              style: new TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: (){
                    shareSong(currentSong);
                  },
                ),
              )
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Text(
                  currentSong.artist,
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: PageIndicatorContainer(
                    child: PageView(
                      children: <Widget>[
                        PageViewPlayer(
                          lirik: currentSong.lirik,
                        ),
                        PageViewPlayer(
                          lirik: currentSong.lirik2,
                        ),
                        PageViewPlayer(
                          lirik: currentSong.lirik3,
                        )
                      ],
                      controller: controller,
                    ),
                    align: IndicatorAlign.bottom,
                    length: 3,
                    indicatorSpace: 20.0,
                    padding: const EdgeInsets.all(10),
                    indicatorColor: Colors.white,
                    indicatorSelectorColor: Color(0xffec2f82),
                    shape: IndicatorShape.circle(size: 8),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        position.inSeconds < 10
                            ? '00.0${position.inSeconds}'
                            : position.inSeconds < 60
                                ? '00.${position.inSeconds}'
                                : position.inSeconds < 70
                                    ? '01.0${position.inSeconds - 60}'
                                    : position.inSeconds < 120
                                        ? '01.${position.inSeconds - 60}'
                                        : position.inSeconds < 130
                                            ? '02.0${position.inSeconds - 120}'
                                            : position.inSeconds < 180
                                                ? '02.${position.inSeconds - 120}'
                                                : position.inSeconds < 190
                                                    ? '03.0${position.inSeconds - 180}'
                                                    : position.inSeconds < 240
                                                        ? '03.${position.inSeconds - 180}'
                                                        : position.inSeconds <
                                                                250
                                                            ? '04.0${position.inSeconds - 240}'
                                                            : position.inSeconds <
                                                                    300
                                                                ? '04.${position.inSeconds - 240}'
                                                                : position.inSeconds <
                                                                        310
                                                                    ? '05.0${position.inSeconds - 300}'
                                                                    : position.inSeconds <
                                                                            360
                                                                        ? '05.${position.inSeconds - 300}'
                                                                        : '06.${position.inSeconds - 360}',
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Container(
                          width: 250,
                          child: SliderTheme(
                            data: SliderThemeData(
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)
                            ),
                            child: Slider(
                                activeColor: Color(0xffec2f82),
                                inactiveColor: Colors.grey,
                                value: duration.inSeconds.toDouble()>position.inSeconds.toDouble() ? position.inSeconds.toDouble() : duration.inSeconds.toDouble(),
                                min: 0.0,
                                max: duration.inSeconds.toDouble()>0?duration.inSeconds.toDouble():0,
                                onChanged: (double value) {
                                 if(mounted){
                                    setState(() {
                                    seekToSecond(value.toInt());
                                    value = value;
                                  });
                                 }
                                }),
                          )),
                      Text(
                        currentSong.time,
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          prevSong();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FloatingActionButton(
                        backgroundColor: Color(0xffec2f82),
                        elevation: 0.0,
                        child: Icon(
                          playing?
                          Icons.pause
                          :
                          Icons.play_arrow
                        ),
                        onPressed: (){
                          playerState == AudioPlayerState.PLAYING? 
                          pauseAudio()
                          :
                          resumeAudio();
                        },
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          nextSong();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
 
  Future playAudio() async {
    final dir = await getApplicationDocumentsDirectory();
  final file = new File("${dir.path}/${currentSong.path}");
  if (!(await file.exists())) {
    final soundData = await rootBundle.load('assets/${currentSong.path}');
    final bytes = soundData.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
  }
    await audioPlayer.play(file.path, isLocal: true);
      setState(() {
      playerState = AudioPlayerState.PLAYING;
      playing = true;
    });
  }

  Future pauseAudio() async {
    await audioPlayer.pause();
    if(mounted){
      setState(() {
      playing = false;
      playerState = AudioPlayerState.PAUSED;
    });
    }
  }

  Future resumeAudio() async {
    playAudio();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }

  void shareSong(Song currentSong){

    String title = currentSong.title;
    String artist = currentSong.artist;
    List<String> lyrics = currentSong.lirik.split(' ');

    String lyric = "";

    for (var i = 0; i < 20; i++) {
      lyric += lyrics[i];
    }
    lyric += ".....";

    String join = "Bergabung bersama saya di BTS Populer!\nhttps://play.google.com/store/apps/details?id=id.deris.topmusik";

    Share.share('$title\n$artist\n$lyric\n\n$join');
  }
}
