import 'package:shared_preferences/shared_preferences.dart';

class Tracker{
  double TotalAttemptedTrivia;
  double TotalAnsweredCorrectly;
  double TotalAnsweredWrong;
  double TotalSkipped;
  double SessionAttemptedTrivia;
  double SessionAnsweredCorrectly;
  double SessionAnsweredWrong;
  double SessionSkipped;

  Tracker(SharedPreferences prefs){
    TotalAttemptedTrivia=prefs.getDouble('Attempt')??0;
    TotalAnsweredCorrectly= prefs.getDouble('Correct')??0;
    TotalAnsweredWrong =prefs.getDouble("Wrong")??0;
    TotalSkipped=prefs.getDouble("Skipped")??0;
    SessionAttemptedTrivia = 0;
     SessionAnsweredCorrectly = 0;
     SessionAnsweredWrong =  0;
     SessionSkipped= 0;
  }
  Future UpdatePrefs(SharedPreferences prefs)async{
    await prefs.setDouble('Attempt',  TotalAttemptedTrivia);
    await prefs.setDouble('Correct',  TotalAnsweredCorrectly);
    await prefs.setDouble('Wrong',  TotalAnsweredWrong);
    await prefs.setDouble('Skipped',  TotalSkipped);
  }

}

