
import 'package:flutter/cupertino.dart';

import '../homeTab/HomeScreen.dart';

class Splashscreen extends StatefulWidget {
  static const String routename = "splash_Screen";
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
          () {
        Navigator.pushReplacementNamed(context,HomeScreen.routeName);
      },
    );
  }

  Widget build(BuildContext context) {
    return Image.asset(
        'Images/splash.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        );
}
}