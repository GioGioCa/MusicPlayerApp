import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( //se volvio constante
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  double value = 0;

  //Se crea una instancia del reproductor
  final player = AudioPlayer();

  //Establecer la duracion
  Duration? duration = const Duration(seconds: 0); //se volvio constante

  //Crear una funcion para inicializar la musica en el reproductor
  void initPlayer() async {
    await player.setSource(AssetSource("music.mp3"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(), //se volvio constante
            decoration: const BoxDecoration( //se volvio constante
                image: DecorationImage(
              image: AssetImage("assets/cover.jpg"),
              fit: BoxFit.cover,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/cover.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox( //se volvio constante
                height: 20,
              ),
              const Text( //se volvio constante
                "Winter Vibes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox( //se volvio constante
                height: 50.0,
              ),

              //Es un contador de la duracion de la musica
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "${(value / 60).floor()}: ${(value % 60).floor()}",
                  style: const TextStyle( //se volvio constante
                    color: Colors.white,
                  ),
                ),
                Slider.adaptive(
                  onChanged: (v) {
                    setState(() {
                      value = v;
                    });
                  },
                  min: 0.0,
                  max: duration!.inSeconds.toDouble(),
                  value: value,
                  onChangeEnd: (newValue) async {
                    setState(() {
                      value = newValue;
                      print(newValue);
                    });
                    player.pause();
                    await player.seek(Duration(seconds: newValue.toInt()));
                    await player.resume();
                  },
                  activeColor: Colors.white,
                ),
                Text(
                  "${duration!.inMinutes} : ${duration!.inSeconds}",
                  style: const TextStyle( //se volvio constante
                    color: Colors.white,
                  ),
                ),
              ]),

              const SizedBox( //se volvio constante
                height: 30.0,
              ),

              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.0),
                  color: Colors.black87,
                  border: Border.all(color: Colors.pink),
                ),
                child: InkWell(
                  onTap: () async {
                    //Aqui se reproduce la musica
                    if (isPlaying) {
                      player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await player.resume();
                      setState(() {
                        isPlaying = true;
                      });

                      player.onPositionChanged.listen(
                        (position) {
                          setState(() {
                            value = position.inSeconds.toDouble();
                          });
                        },
                      );
                    }
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
