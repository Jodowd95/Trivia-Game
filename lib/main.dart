import 'package:flutter/material.dart';
import 'package:trivia_game_app2/UI/home_screen.dart';
import 'models/tracker.dart';
import 'models/trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main()async{
  Trivia initialQuestion = new Trivia('sports');
  await initialQuestion.GetQuestion();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Tracker myTracker = new Tracker(prefs); //needs to be after SharedPreferences
  runApp(new MaterialApp(
    title: 'Generic Trivia Game!',
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),

    home: HomeScreen(title:'Trivia the game', currentQuestion: initialQuestion, myTracker: myTracker,myprefs: prefs),
  ),
  );
}




