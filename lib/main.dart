import 'package:flutter/material.dart';

import 'package:movies_app/searchScreen/search.dart';
import 'package:movies_app/splash%20screen/splash%20screen.dart';

import 'homeTab/HomeScreen.dart';
import 'homeTab/mainScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //  home: HomeScreen(),
      home: Splashscreen(),
      routes: {
        HomeTab
            .routename :(context) =>HomeTab(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SearchScreen.routename: (context) => SearchScreen(),


      },
    );

      }
  }