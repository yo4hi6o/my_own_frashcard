import 'package:flutter/material.dart';
import 'package:my_own_frashcard/db/database.dart';
import 'package:my_own_frashcard/main.dart';
import 'package:my_own_frashcard/screens/word_list_screen.dart';

import 'package:toast/toast.dart';
import 'package:sqlite3/src/api/exception.dart';

enum EditStatus { ADD, EDIT }

class EditScreen extends StatefulWidget {
  final EditStatus status;

  final Word word;

  EditScreen({@required this.status, this.word});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  String _titleText = "";

  bool _isQuestionEnabled;

  @override
  void initState() {
    super.initState();
    if (widget.status == EditStatus.ADD) {
      _isQuestionEnabled = true;
      _titleText = "新しい単語の追加";
      questionController.text = "";
      answerController.text = "";
    } else {
      _isQuestionEnabled = false;
      _titleText = "登録した単語の修正";
      questionController.text = widget.word.strQuestion;
      answerController.text = widget.word.strAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backToWordListScreen(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              tooltip: "登録",
              onPressed: () => _onWordRegistered(),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Text(
                  "問題と答えを入力して「登録」ボタンを押してください",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              //問題入力部分
              _questionInputPart(),

              _answerInputPart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          Text(
            "問題",
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            enabled: _isQuestionEnabled,
            controller: questionController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0),
          )
        ],
      ),
    );
  }

  Widget _answerInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          Text(
            "答え",
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: answerController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0),
          )
        ],
      ),
    );
  }

  Future<bool> _backToWordListScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WordListScreen()));
    return Future.value(false);
  }

  _onWordRegistered() {
    if (widget.status == EditStatus.ADD) {
      _insertWord();
    } else {
      _updateWord();
    }
  }

  _insertWord() async {
    if (questionController.text == "" || answerController.text == "") {
      Toast.show("問題と答えの両方を入力しないと登録できませ。", context,
          duration: Toast.LENGTH_LONG);
      return;
    }

    showDialog(context: context, builder: (_) =>
        AlertDialog(
          title: Text("登録"),
          content: Text("登録していいですか？"),
          actions: [
            FlatButton(
              child: Text("はい"),
              onPressed: () async {
                var word = Word(
                    strQuestion: questionController.text,
                    strAnswer: answerController.text);

                try {
                  await dataBase.addWord(word);
                  print("OK");
                  questionController.clear();
                  answerController.clear();
                  //TODO　登録完了メッセージ
                  Toast.show("登録完了しました。", context, duration: Toast.LENGTH_LONG);
                } on SqliteException catch (e) {
                  Toast.show("この問題は既に登録されています。", context,
                      duration: Toast.LENGTH_LONG);
                } finally {
                  Navigator.pop(context);
                }
              },
            ),

            FlatButton(
                child: Text("いいえ"),
                onPressed: () => Navigator.pop(context)
            )
          ],

        ));


    void _updateWord () async {
      if (questionController.text == "" || answerController.text == "") {
        Toast.show("問題と答えの両方を入力しないと登録できませ。", context,
            duration: Toast.LENGTH_LONG);
        return;
      }

      showDialog(context: context,builder: (_) => AlertDialog(
        title: Text("${questionController.text}の変更"),
        content: Text("変更してもいいですか？"),
        actions: [
          FlatButton(
          child: Text("はい"),
      onPressed: () async {
        var word = Word(
            strQuestion: questionController.text,
            strAnswer: answerController.text,
            isMemorized: false);

        try {
          await dataBase.updateWord(word);
          _backToWordListScreen();
          Toast.show("修正が完了しました。", context, duration: Toast.LENGTH_LONG);
        } on SqliteException catch (e) {
          Toast.show("何らかの問題が発生し登録できません。: $e", context,
              duration: Toast.LENGTH_LONG);
          return;
        } finally {
          Navigator.pop(context);
         }
        },
       ),
        FlatButton(
        child: Text("いいえ"),
        onPressed: () => Navigator.pop(context),
      )

        ],
      ));


      }
    }

  void _updateWord() {if (questionController.text == "" || answerController.text == "") {
    Toast.show("問題と答えの両方を入力しないと登録できませ。", context,
        duration: Toast.LENGTH_LONG);
    return;
  }

  showDialog(context: context,builder: (_) => AlertDialog(
    title: Text("${questionController.text}の変更"),
    content: Text("変更してもいいですか？"),
    actions: [
      FlatButton(
        child: Text("はい"),
        onPressed: () async {
          var word = Word(
              strQuestion: questionController.text,
              strAnswer: answerController.text,
              isMemorized: false);

          try {
            await dataBase.updateWord(word);
            Navigator.pop(context);

            _backToWordListScreen();
            Toast.show("修正が完了しました。", context, duration: Toast.LENGTH_LONG);
          } on SqliteException catch (e) {
            Toast.show("何らかの問題が発生し登録できません。: $e", context,
                duration: Toast.LENGTH_LONG);
            Navigator.pop(context);

          }
        },
      ),
      FlatButton(
        child: Text("いいえ"),
        onPressed: () => Navigator.pop(context),
      )

    ],
  ));


  }
  }
