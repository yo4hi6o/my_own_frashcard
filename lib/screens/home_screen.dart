import 'package:flutter/material.dart';
import 'package:my_own_frashcard/parts/button_with_icon.dart';
import 'package:my_own_frashcard/screens/test_screen.dart';
import 'package:my_own_frashcard/screens/word_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isIncludedMemorizedWord = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/images/image_title.png")),
            _titleText(),
            Divider(
              height: 30.0,
              color: Colors.white,
              indent: 8.0,
              endIndent: 8.0,
            ),

            //確認テストをするボタン,
            ButtonWithIcon(
              onPressed: () => _startTestScreen(context),
              icon: Icon(Icons.play_arrow),
              label: "かくにんテストをする",
              color: Colors.brown,
            ),
            SizedBox(
              height: 10.0,
            ),
            //ラジオボタン,
            _radioButtons(),
            //切替トグル（switch)
            // _switch(),
            SizedBox(
              height: 30.0,
            ),
            //TODO 単語一覧を見るボタン,
            ButtonWithIcon(
              onPressed: () => _startWordListScreen(context), //
              icon: Icon(Icons.list),
              label: "単語一覧を見る",
              color: Colors.grey,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "powerd by kanna 2020",
              style: TextStyle(fontFamily: "Mont"),
            ),
            SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return Column(
      children: [
        Text(
          "私だけの単語帳",
          style: TextStyle(
            fontSize: 40.0,
          ),
        ),
        Text(
          "My Own Frashcard",
          style: TextStyle(fontSize: 24.0, fontFamily: "Mont"),
        ),
      ],
    );
  }

  Widget _radioButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(
        children: [
          RadioListTile(
            title: Text(
              "暗記済みの単語を除外する",
              style: TextStyle(fontSize: 16.0),
            ),
            value: false,
            groupValue: isIncludedMemorizedWord,
            onChanged: (value) => _onRadioSelected(value),
          ),
          RadioListTile(
            title: Text(
              "暗記済みの単語を含む",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: isIncludedMemorizedWord,
            onChanged: (value) => _onRadioSelected(value),
          ),
        ],
      ),
    );
  }

  _onRadioSelected(value) {
    setState(() {
      isIncludedMemorizedWord = value;
      print("$valueが選ばれたデー！");
    });
  }

  // Widget _switch() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //     child: SwitchListTile(
  //       title: Text("暗記済みの単語を含む"),
  //       value: isIncludedMemorizedWord,
  //       onChanged: (value){
  //         setState(() {
  //           isIncludedMemorizedWord = value;
  //         });
  //       },
  //       secondary: Icon(Icons.sort),
  //     ),
  //   );
  //
  // }

  _startWordListScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WordListScreen()));
  }

  _startTestScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TestScreen(
                  isIncludedMemorizedWord: isIncludedMemorizedWord,
                )));
  }


}