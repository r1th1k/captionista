import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'variables.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void picker() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['mp3', 'mp4', 'wav']);

    if (result != null) {
      setState(() {
        fileName = result.files.first.name;
        impBtn = true;
      });
      file = File(result.files.single.path!.toString());
      fle = file!.path;
    }
  }

  Future<void> importer() async {
    setState(() {
      impBtn = false;
      anime = true;
      impAnime = true;
    });

    FormData data = FormData.fromMap({
      'dat': await MultipartFile.fromFile(fle, filename: "data"),
    });

    dio.post("http://192.168.43.17:1234/upload", data: data,
        onSendProgress: (int count, int total) {
      if (total - count == 0) {
        setState(() {
          genButton = true;
          anime = false;
          impAnime = false;
        });
      }
    });
  }

  void gen() async {
    setState(() {
      genButton = false;
      anime = true;
      genAnime = true;
      chooseBtn = false;
    });

    dio.get(
      "http://192.168.43.17:1234/processing",
      onReceiveProgress: (count, total) {
        if (count - total == 0) {
          setState(() {
            downBtn = true;
            anime = false;
            genAnime = false;
          });
        }
      },
    );
  }

  void download() async {
    setState(() {
      downBtn = false;
      anime = false;
      downAnime = true;
    });

    dio.download("http://192.168.43.17:1234/download/srt",
        "/home/d4rk/Downloads/subtitle.srt");

    dio.download(
      "http://192.168.43.17:1234/download/vtt",
      "/home/d4rk/Downloads/subtitle.vtt",
      onReceiveProgress: (count, total) {
        if (total - count == 0) {
          setState(() {
            file;
            fileName = 'choose file';

            genButton = false;
            downBtn = false;
            impBtn = false;
            chooseBtn = true;

            fle = "";
            dio = Dio();

            anime = false;
            impAnime = false;
            genAnime = false;
            downAnime = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Captionista"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (impAnime)
                Lottie.asset('animation/imp.json',
                    height: 500, width: 500, repeat: true),
              if (genAnime)
                Lottie.asset('animation/gen.json',
                    height: 500, width: 500, repeat: true),
              if (downAnime)
                Lottie.asset('animation/down.json',
                    height: 500, width: 500, repeat: true),
              if (!anime)
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //choose button
                    if (chooseBtn)
                      ElevatedButton(
                        onPressed: () {
                          picker();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            fileName,
                            style: const TextStyle(fontSize: 70),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 35,
                    ),

                    //IMPORT BUTTON
                    if (impBtn)
                      ElevatedButton(
                        onPressed: () {
                          importer();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Import',
                            style: TextStyle(fontSize: 70),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 35,
                    ),

                    //GENERATE BUTTON
                    if (genButton)
                      ElevatedButton(
                        onPressed: () {
                          gen();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Generate',
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),

                    //DOWNLOAD BUTTON
                    if (downBtn)
                      ElevatedButton(
                        onPressed: () {
                          download();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Download',
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
