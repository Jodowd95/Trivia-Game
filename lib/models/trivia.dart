import 'dart:convert';
import 'answer.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class Trivia{
  String Category;
  String Type;
  String Difficulty;
  String Question;
  List<Answer> PossibleAnswers;
  bool AnsweredCorrectly;

  Trivia (this.Category){
    PossibleAnswers= new List<Answer>();
  }
  Future GetQuestion()async{
    String apiURL= 'https://opentdb.com/api.php?amount=10';
    try{
      var unescape= new HtmlUnescape();
      PossibleAnswers.clear();
      http.Response response=  await http.get(apiURL);
      Map decodeList= json.decode(response.body);
      List detailedMap= decodeList['results'];
      String category = detailedMap[0]['category'];
      String type= detailedMap[0]['type'];
      String difficulty = detailedMap[0]['difficulty'];
      String question = unescape.convert(detailedMap[0]['question']);
      String correctAnswer = unescape.convert(detailedMap [0]['correct_answer']);
      PossibleAnswers.add(new Answer(correctAnswer, true));
      List incorrectAnswersList = detailedMap[0]['incorrect_answers'];
      await incorrectAnswersList.forEach((element)async{
       PossibleAnswers.add(new Answer(element, false));
      });
      PossibleAnswers.shuffle();
      String blah = 'u';
      Question = question;
      Category = category;
      Difficulty = difficulty;
      Question = question;
      Type = type;
    } catch(e){
      print(e.toString());
    }
  }

}