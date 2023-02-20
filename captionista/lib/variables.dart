import 'dart:io';
import 'package:dio/dio.dart';

File? file;
String fileName = 'choose file';
String fle = "";
var dio = Dio();

bool genButton = false;
bool downBtn = false;
bool impBtn = false;
bool chooseBtn = true;

bool anime = false;
bool impAnime = false;
bool genAnime = false;
bool downAnime = false;

bool srt = false;
bool vtt = false;
