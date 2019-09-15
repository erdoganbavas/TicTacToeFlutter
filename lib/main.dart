import 'package:flutter/material.dart';

import 'game.dart';
import 'helpers/game_colors.dart';
import 'helpers/game_type.dart';
import 'helpers/size_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeHelper sizeHelper = SizeHelper(context);
    double buttonWidth =
    (sizeHelper.width / 1.5) > 300.0 ? 300.0 : sizeHelper.width / 1.5;
    buttonWidth = buttonWidth<100?100:buttonWidth;
    print(buttonWidth);

    return Container(
      color: GameColors.MainBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Container(
                constraints: BoxConstraints.expand(
                    width: buttonWidth,
                    height: 70
                ),
                padding: EdgeInsets.symmetric(vertical: 25),
                width: buttonWidth,
                child: Center(child: Text("Bot : Easy"))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GamePage(type: GameType.BotEasy)),
              );
            },
          ),
          SizedBox(height: 15,),
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                width: buttonWidth, child: Center(child: Text("Bot : Hard"))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GamePage(type: GameType.BotHard)),
              );
            },
          ),
          SizedBox(height: 15,),
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                width: buttonWidth, child: Center(child: Text("2 Player"))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GamePage(type: GameType.TwoPlayer)),
              );
            },
          ),
        ],
      ),
    );
  }
}