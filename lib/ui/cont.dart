import 'package:flutter/material.dart';
import 'package:trivia_game_app2/models/trivia.dart';


class Questions extends StatefulWidget {
  Questions({Key key, this.title, this.currentQuestion}) : super(key: key);
  final String title;
  Trivia currentQuestion;
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generic trivia game number 5.23"),
      ),
      backgroundColor: Color.fromRGBO(254, 197, 55, 1),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to this trivia! Are you in preperation for the trivia?',
            ),
            Text(
                'Question: ${widget.currentQuestion.Question}'
            ),
            new RaisedButton(
              child:const Text ('Begin the trivia'),
              color: Theme.of(context).accentColor,
              elevation: 10.0,
              splashColor: Colors.lightBlue,
              onPressed: (){
                //enter into trivia game
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
