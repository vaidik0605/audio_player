import 'package:audio_player/Model/Model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Play_Music_Screen extends StatefulWidget {
  int index;

  Play_Music_Screen(this.index);

  @override
  State<Play_Music_Screen> createState() => _Play_Music_ScreenState();
}

class _Play_Music_ScreenState extends State<Play_Music_Screen>
    with TickerProviderStateMixin {
  AudioPlayer player = AudioPlayer();
  Duration position = Duration.zero;

  String url =
      "https://rukminim1.flixcart.com/image/416/416/jcc9ci80/poster/f/b/r/medium-pl-music-dark-record-pictures-vinyls-wall-poster-13-19-original-imaetdwgeu5hmjvj.jpeg?q=70";
  AnimationController? animationController;
  Animation<double>? animation;

  String song_duration = "";
  @override
  void initState() {
    super.initState();
    durationconvrt();
    player.onPositionChanged.listen((newPostion) {
      position = newPostion;
    });
  }

  void durationconvrt() {
    int? duration = Model.song[widget.index].duration;
    double adsecond = 0;
    double second = 0;
    double sq = 0;
    if (duration! > 1000) {
      sq = (duration / 1000);
      second = duration % 1000;
    }

    adsecond = adsecond + sq;

    print("Ad Second : ${adsecond.toInt()}");
    print("Second : ${second.toInt()}");

    double adminute = 0;
    double mq = 0;
    double minute = 0;
    if (adsecond > 60) {
      mq = adsecond / 60;
      minute = adsecond % 60;
    }

    adminute = adminute + mq;

    print("Ad Minute : ${adminute.toInt()}");
    print("Minute : ${minute.toInt()}");
    double hq = 0;
    double hour = 0;
    double adhour = 0;
    if (adminute > 60) {
      hq = adminute / 60;
      hour = adminute % 60;
    }
    adhour = adhour + hq;
    print("Ad hour : ${adhour.toInt()}");
    print("hour : ${hour.toInt()}");
    if (adminute.toInt() < 10 && minute.toInt() < 10) {
      song_duration = "0${adminute.toInt()} : 0${minute.toInt()}";
    } else if (adminute.toInt() < 10) {
      song_duration = "0${adminute.toInt()} : ${minute.toInt()}";
    } else if (minute.toInt() < 10) {
      song_duration = "${adminute.toInt()} : 0${minute.toInt()}";
    } else {
      song_duration = "${adminute.toInt()} : ${minute.toInt()}";
    }
  }

  SharedPreferences? prefs;
  bool isplay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play_Music_Screen"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () async {
              await player.stop();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      //backgroundColor: Colors.purple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(140),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    blurStyle: BlurStyle.normal,
                  ),
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    blurStyle: BlurStyle.normal,
                  ),
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    blurStyle: BlurStyle.normal,
                  ),
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: QueryArtworkWidget(
                  artworkFit: BoxFit.cover,
                  id: Model.song[widget.index].id,
                  type: ArtworkType.AUDIO),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            alignment: Alignment.center,
            child: Text(
              "${Model.song[widget.index].title}",
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Slider(
            min: 0,
            max: Model.song[widget.index].duration!.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await player.seek(position);

              await player.resume();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  position.toString().split(".").first,
                  //  style: const TextStyle(color: Colors.white),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Text(
                  song_duration,
                  // style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          (isplay)
              ? GestureDetector(
                  onTap: () async {
                    isplay = false;
                    setState(() {});
                    await player.pause();
                  },
                  child: const Icon(
                    Icons.pause,
                    // color: Colors.white,
                    size: 50,
                  ))
              : GestureDetector(
                  onTap: () async {
                    isplay = true;
                    setState(() {});
                    await player
                        .play(DeviceFileSource(Model.song[widget.index].data));
                  },
                  child: const Icon(
                    Icons.play_arrow,
                    // color: Colors.white,
                    size: 50,
                  )),
        ],
      ),
    );
  }
}
