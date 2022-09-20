import 'package:audio_player/Model/Model.dart';
import 'package:audio_player/Play_Music_Screen/Play_Music_Screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class View_Screen extends StatefulWidget {
  const View_Screen({Key? key}) : super(key: key);

  @override
  State<View_Screen> createState() => _View_ScreenState();
}

class _View_ScreenState extends State<View_Screen> {
  AudioPlayer player = AudioPlayer();

  List<bool> statuslist = [];
  @override
  void initState() {
    super.initState();
    statuslist = List.filled(Model.song.length, false);
  }

  bool sortlist = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            backgroundColor: Colors.black,
            actions: [
              PopupMenuButton(
                elevation: 20,
                onSelected: (value) async {
                  if (value == 1) {
                    sortlist = true;
                    Model.song.sort(
                      (a, b) => a.title
                          .toUpperCase()
                          .compareTo(b.title.toUpperCase()),
                    );
                  } else {
                    sortlist = false;
                    Model.song.sort((a, b) => a.artist!
                        .toUpperCase()
                        .compareTo(b.artist!.toUpperCase()));
                  }
                  setState(() {});
                },
                color: Colors.white,
                icon: Icon(Icons.more_vert_rounded),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.check,
                            color: (sortlist == true) ? Colors.blue : null,
                          ),
                          Text("Sort by name"),
                        ],
                      )),
                  PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: (sortlist == false) ? Colors.blue : null,
                          ),
                          Text("Sort by Artist"),
                        ],
                      )),
                ],
              )
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  title: Text("Music Player"),
                  centerTitle: true,
                  background: Image.network(
                    fit: BoxFit.fill,
                    "https://rukminim1.flixcart.com/image/416/416/jcc9ci80/poster/f/b/r/medium-pl-music-dark-record-pictures-vinyls-wall-poster-13-19-original-imaetdwgeu5hmjvj.jpeg?q=70",
                  ), //Images.networ// k
                );
              },
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: Model.song.length,
            (context, index) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2, left: 2),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50)),
                        color: Colors.black),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Play_Music_Screen(index);
                          },
                        ));
                      },
                      leading: QueryArtworkWidget(
                          id: Model.song[index].id, type: ArtworkType.AUDIO),
                      title: Text(
                        "${Model.song[index].title}",
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${Model.song[index].artist}",
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ))
        ],
      ),
    );
  }
}
