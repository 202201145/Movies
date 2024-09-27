import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:movies_app/searchScreen/search.dart';
import 'package:movies_app/splash%20screen/splash%20screen.dart';
import 'package:movies_app/splash%20screen/splash%20screen.dart';

import 'firebase_options.dart';
import 'homeTab/HomeScreen.dart';
import 'homeTab/mainScreen.dart';



  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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