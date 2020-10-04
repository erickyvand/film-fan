import 'package:film_fan/Home.dart';
import 'package:film_fan/NowMovies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(
    MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/movies': (context) => NowMovies(),
      },
    ),
  );
}
