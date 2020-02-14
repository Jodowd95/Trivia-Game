import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_game_app2/models/answer.dart';
import 'package:trivia_game_app2/models/tracker.dart';
import 'package:trivia_game_app2/models/trivia.dart';
import 'package:pie_chart/pie_chart.dart';


class HomeScreen extends StatefulWidget {
  final Tracker myTracker;
  final String title;
  Trivia currentQuestion;
  SharedPreferences myprefs;


  HomeScreen({Key key, this.title, this.currentQuestion, this.myTracker, this.myprefs}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool AnsweredCorrectly;
  Answer SelectedAnswer;
  bool Answered;
  Map<String,double> dataMap;
  List<Color> colorList = [
    Colors.green,
    Colors.red,
    Colors.blue
  ];

  @override
  void initState() {
    // TODO: implement initState
    dataMap = new Map();
    dataMap.putIfAbsent("Correct", () => widget.myTracker.SessionAnsweredCorrectly);
    dataMap.putIfAbsent("Wrong", () => widget.myTracker.SessionAnsweredWrong);
    dataMap.putIfAbsent("Skipped", () => widget.myTracker.SessionSkipped);
    super.initState();
  }

  void updateMap(){
    dataMap = new Map();
    dataMap.putIfAbsent("Correct", () => widget.myTracker.SessionAnsweredCorrectly);
    dataMap.putIfAbsent("Wrong", () => widget.myTracker.SessionAnsweredWrong);
    dataMap.putIfAbsent("Skipped", () => widget.myTracker.SessionSkipped);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          "This is a Time for Trivia",
          style: TextStyle(
              fontSize: 30.0
          ),
        ),
      ),
      body: Stack(
        children:<Widget>[
          Center(
            child: Image.asset('images/background.jpg',
              width: 490.0,
              height: 12000.0,
              fit: BoxFit.fill,),
          ),
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.blue.shade200,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Attempted: ${widget.myTracker.SessionAttemptedTrivia}"),
                    ),

                    Container(width: 10.0),
                    Icon(Icons.check_circle,color: Colors.green,),
                    Text(widget.myTracker.SessionAnsweredCorrectly.toString()),
                    Container(width: 10.0),
                    Icon(Icons.cancel,color: Colors.red,),
                    Text(widget.myTracker.SessionAnsweredWrong.toString()),
                    Container(width: 10.0),
                    Icon(Icons.play_circle_filled,color: Colors.blueAccent,),
                    Text(widget.myTracker.SessionSkipped.toString()),
                    Container(width: 10.0),
                  ],
                ),
              ),

            ),
            widget.myTracker.SessionAttemptedTrivia==0?Container():
            PieChart(
              dataMap: dataMap, //Required parameter
              legendFontColor: Colors.blueGrey[900],
              legendFontSize: 25.0,
              legendFontWeight: FontWeight.w500,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery
                  .of(context)
                  .size
                  .width / 6,
              showChartValuesInPercentage: false,
              showChartValues: false,
              showChartValuesOutside: true,
              chartValuesColor: Colors.white,
              colorList: colorList,
              showLegends: false,
              decimalPlaces: 0,
              //initialAngle: math.pi*0.5,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                '${widget.currentQuestion.Question}',
                style: TextStyle(fontSize: 28.9,),
                textAlign: TextAlign.center,
              ),
            ),
//          Text(
//            'Question Type: ${widget.currentQuestion.QuestionType}',
//            style: TextStyle(fontSize: 16.9),
//            textAlign: TextAlign.center,
//          ),
            Container(height: 20.0,),
            Text(
              'Select the correct answer below',
              style: TextStyle(fontSize: 16.9),
              textAlign: TextAlign.center,
            ),
            BuildAnswers(context),
            Answered==true?RaisedButton(
                color: Colors.green,
                elevation: 10.0,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Get Next Question",
                  style: TextStyle(color: Colors.white, fontSize: 18.9),
                ),
                onPressed: ()async{
                  await widget.currentQuestion.GetQuestion();
                  setState(() {
                    updateMap();
                    Answered=false;
                    AnsweredCorrectly=null;
                  });
                }
            ):RaisedButton(
                color: Colors.blueAccent,
                elevation: 10.0,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Skip this Question",
                  style: TextStyle(color: Colors.white, fontSize: 18.9),
                ),
                onPressed: ()async{
                  await widget.currentQuestion.GetQuestion();
                  setState(() {
                    widget.myTracker.SessionAttemptedTrivia++;
                    widget.myTracker.SessionSkipped++;
                    widget.myTracker.TotalAttemptedTrivia++;
                    widget.myTracker.TotalSkipped++;
                    updateMap();
                    Answered=false;
                    AnsweredCorrectly=null;
                  });
                  await widget.myTracker.UpdatePrefs(widget.myprefs);
                }
            )
          ],
        ),
      ]
      ),
    );
  }

  Widget BuildAnswers(BuildContext context){
    List<Answer> answerList = widget.currentQuestion.PossibleAnswers;

    return Flexible(
      child: ListView.builder(
        itemCount: answerList.length,
        itemBuilder: (BuildContext context, int position){
          Answer tempAnswer = answerList[position];
          Color cardColor = Colors.grey.shade600;
          if (AnsweredCorrectly==true && SelectedAnswer.StrAnswer==tempAnswer.StrAnswer){
            cardColor= Colors.green.shade600;
          }
          if (AnsweredCorrectly==false && SelectedAnswer.StrAnswer==tempAnswer.StrAnswer){
            cardColor= Colors.red.shade600;

          }
          return Padding(
            padding: EdgeInsets.only(left:15.0,right: 15.0,top: 8.0),
            child: RaisedButton(
                color: cardColor,
                elevation: 10.0,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "${tempAnswer.StrAnswer}",
                  style: TextStyle(color: Colors.white, fontSize: 18.9),
                ),
                onPressed: ()async{
                  if (Answered==true){}else{
                    if (tempAnswer.CorrectAnswer==true){
                      setState(() {
                        AnsweredCorrectly=true;
                        SelectedAnswer = tempAnswer;
                        Answered=true;
                        setState(() {
                          widget.myTracker.SessionAttemptedTrivia++;
                          widget.myTracker.SessionAnsweredCorrectly++;
                          widget.myTracker.TotalAttemptedTrivia++;
                          widget.myTracker.TotalSkipped++;
                          updateMap();
                        });
                      });
                      await widget.myTracker.UpdatePrefs(widget.myprefs);
                    }else{
                      setState(() {
                        AnsweredCorrectly=false;
                        SelectedAnswer = tempAnswer;
                        Answered=true;
                        setState(() {
                          widget.myTracker.SessionAttemptedTrivia++;
                          widget.myTracker.SessionAnsweredWrong++;
                        });
                      });
                    }
                  }
                }
            ),
          );
        },
      ),
    );
  }
}