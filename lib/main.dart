
import 'package:chatbot/splashscreen.dart';
import 'package:flutter/material.dart';

import 'bot.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mining Law Chatbot',
      debugShowCheckedModeBanner : false,
      theme: ThemeData(
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,

        ),
      ),
      home: SplashScreen(),
    );
  }
}