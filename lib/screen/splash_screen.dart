import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/constant/routes_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 42,
              color: Colors.orange,
              fontWeight: FontWeight.bold
            ),
            child: AnimatedTextKit(
              onFinished: (){
                Navigator.of(context).pushReplacementNamed(homeScreenRoute);
              },
              isRepeatingAnimation: false,
              animatedTexts: [
                FadeAnimatedText("EAT", duration: const Duration(milliseconds: 1000)),
                FadeAnimatedText("DRINK", duration: const Duration(milliseconds: 1000)),
                FadeAnimatedText("LOVE", duration: const Duration(milliseconds: 1000)),
              ]
            ),
          ),
        ),
      ),
    );
  }
}