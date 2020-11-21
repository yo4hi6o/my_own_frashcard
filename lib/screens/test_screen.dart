import 'package:flutter/material.dart';
import 'package:my_own_frashcard/db/database.dart';
import 'package:my_own_frashcard/main.dart';

enum TestStatus { BEFORE_START, SHOW_QUESTION, SHOW_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  final bool isIncludedMemorizedWord;

  TestScreen({this.isIncludedMemorizedWord});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _unmberOfQuestion = 0;

  String _txtQuestion = "テスト"; //TODO

  String _txtAnswer = "こたえ"; //TODO
  bool _isMemorized = false;

  bool _isQuestionCardVisible = false;
  bool _isAnswerCardVisible = false;
  bool _isCheckBoxVisible = false;
  bool _isFabVisible = false;

  List<Word> _testDataList = List();
  TestStatus _testStatus;

  int _index = 0; //今何問目
  Word _currentWord;

  @override
  void initState() {
    super.initState();
    _getTestData();
  }

  void _getTestData() async {
    if (widget.isIncludedMemorizedWord) {
      _testDataList = await dataBase.allWords;
    } else {
      _testDataList = await dataBase.allWordsExcludedMemorized;
    }
    _testDataList.shuffle();
    _testStatus = TestStatus.BEFORE_START;
    _index = 0;

    print(_testDataList.toString());

    setState(() {
      _isAnswerCardVisible = false;
      _isAnswerCardVisible = false;
      _isCheckBoxVisible = false;
      _isFabVisible = true;

      _unmberOfQuestion = _testDataList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("かくにんテスト"),
        centerTitle: true,
      ),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: () => _goNextStatus(),
              child: Icon(Icons.skip_next),
              tooltip: "次に進む",
            )
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              _numberOfQuestionsPart(),
              SizedBox(
                height: 30.0,
              ),
              _questionCardPart(),
              SizedBox(
                height: 30.0,
              ),
              _answerCard(),
              SizedBox(
                height: 15.0,
              ),
              _isMemorizedCheckPart(),
            ],
          ),
          _endMessage(),
        ],
      ),
    );
  }

  // 残り問題表示部分
  Widget _numberOfQuestionsPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "のこり問題数",
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 30.0,
        ),
        Text(
          _unmberOfQuestion.toString(),
          style: TextStyle(fontSize: 24.0),
        )
      ],
    );
  }

  // 問題カード表示部分
  Widget _questionCardPart() {
    if (_isQuestionCardVisible) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/image_flash_question.png"),
          Text(
            _txtQuestion,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  //TODO 答えカード表示部分
  Widget _answerCard() {
    if (_isAnswerCardVisible) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/image_flash_answer.png"),
          Text(
            _txtAnswer,
            style: TextStyle(
              fontSize: 20.0,
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _isMemorizedCheckPart() {
    if (_isCheckBoxVisible) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
              value: _isMemorized,
              onChanged: (value) {
                setState(() {
                  _isMemorized = value;
                });
              }),
          Text(
            "暗記済みにする場合はチェック",
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      );
    } else {
      return Container();
    }
    //CheckBox(checkBOxタイトルの左側）

    // CheckboxListTile(checkBoxがタイトルの右側)
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 40.0),
    //   child: CheckboxListTile(
    //     title: Text(
    //       "暗記済みにする場合はチェック",
    //       style: TextStyle(fontSize: 12.0),
    //           ),
    //     value: _isMemorized,
    //     onChanged: (value){
    //       setState(() {
    //         _isMemorized =value;
    //       });
    //     },
    //
    //   ),
    // );
  }

//テスト終了メッセージ
  Widget _endMessage() {
    if (_testStatus == TestStatus.FINISHED) {
      return Center(
        child: Text(
          "テスト終了",
          style: TextStyle(fontSize: 50.0),
        ),
      );
    } else {
      return Container();
    }
  }

  _goNextStatus() async {
    switch (_testStatus) {
      case TestStatus.BEFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        _showQuestion();
        break;
      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOW_ANSWER;
        _showAnswer();
        break;
      case TestStatus.SHOW_ANSWER:
        await _updateMemorizedFlag();
        if (_unmberOfQuestion <= 0) {
          setState(() {
            _isFabVisible = false;





            _testStatus = TestStatus.FINISHED;
          });
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
          _showQuestion();
        }
        break;
      case TestStatus.FINISHED:
        break;
    }
  }

  void _showQuestion() {
    _currentWord = _testDataList[_index];
    setState(() {
      _isQuestionCardVisible = true;
      _isAnswerCardVisible = false;
      _isCheckBoxVisible = false;
      _isFabVisible = true;
      _txtQuestion = _currentWord.strQuestion;
    });

    _unmberOfQuestion -= 1;
    _index += 1;
  }

  void _showAnswer() {
    setState(() {
      _isCheckBoxVisible = true;
      _isAnswerCardVisible = true;
      _isCheckBoxVisible = true;
      _isFabVisible = true;
      _txtAnswer = _currentWord.strAnswer;
      _isMemorized = _currentWord.isMemorized;
    });
  }

  Future<void> _updateMemorizedFlag() async {
    var updateWord = Word(
        strQuestion: _currentWord.strQuestion,
        strAnswer: _currentWord.strAnswer,
        isMemorized: _isMemorized);
    await dataBase.updateWord(updateWord);
    print(updateWord.toString());
  }
}
