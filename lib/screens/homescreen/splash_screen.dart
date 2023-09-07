import 'package:flutter/material.dart';
import 'package:tbib_splash_screen/splash_screen.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

import 'homescreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   bool isLoaded = false;
@override

Future <void>returnToHome()async{
await Future.delayed(Duration(seconds: 5));
Navigator.pushReplacement(context, MaterialPageRoute(builder:  (context) => HomeScreen(),));
}
@override
  void initState() {
   returnToHome();
    super.initState();
  }
  Widget build(BuildContext context) {
    return  SplashScreenView(
      navigateWhere: isLoaded,
      navigateRoute: const HomeScreen(), backgroundColor: Colors.white,
      linearGradient: LinearGradient(
                colors: [ Color(0xFF800080), // Purple
                  Color(0xFF9932CC), // Dark Orchid
                  Color(0xFFDA70D6), // Orchid Color(0xFF800080), // Purple
                  Color(0xFF9932CC), // Dark Orchid
                  Color(0xFFDA70D6), // Orchid
      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      text: WavyAnimatedText(
        "Money Matrix",
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      imageSrc: "assets/icon.jpeg",
      //  displayLoading: false,
    );
  
  }
}