import 'package:flutter/material.dart';
import 'package:tictactoe/bloc/bloc_provider.dart';
import 'package:tictactoe/helpers/game_type.dart';
import 'package:tictactoe/helpers/sign.dart';

import 'package:tictactoe/bloc/game_bloc.dart';

class GameOverPop extends StatefulWidget {
  @override
  _GameOverPopState createState() => _GameOverPopState();
}

class _GameOverPopState extends State<GameOverPop>
    with SingleTickerProviderStateMixin {
  GameBloc _gameBloc;
  Sign _winner;
  String _message = "";
  TextStyle _textStyle;

  TextStyle _winTextStyle = TextStyle(
    color: Colors.white,
    decoration: TextDecoration.none,
  );
  TextStyle _loseTextStyle = TextStyle(
    color: Colors.red,
    decoration: TextDecoration.none,
  );

  Animation<double> _popAnimation;
  AnimationController _popController;

  @override
  void initState() {
    super.initState();
    _gameBloc = BlocProvider.of(context);

    _initListeners();
    _initAnimations();
  }

  @override
  Widget build(BuildContext context) {
    if (_winner != null) {
      return Container(
        color: Color.fromARGB(80, 0, 0, 70),
        child: Center(
          child: ScaleTransition(
            scale: _popAnimation,
            child: Container(
              child: Text(
                _message,
                style: _textStyle,
              ),
            ),
          ),
        ),
      );
    } else {
      // no winner yet, place placeholder
      return Container();
    }
  }

  _initListeners() {
    _gameBloc.gameOver.listen((Sign winner) {
      setState(() {
        _winner = winner;

        // set message according to winner and game type
        _setMessage();

        _popController.forward();
      });
    });

    _gameBloc.reset.listen((reset) {
      if (reset == true) {
        setState(() {
          _popController.reverse().then((value){
            setState(() {
              // unset winner after animation
              _winner = null;
            });
          });
        });
      }
    });
  }

  _initAnimations() {
    _popController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _popAnimation = Tween<double>(begin: .0, end: 1)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_popController);
  }

  _setMessage() {
    if (_gameBloc.type == GameType.BotEasy ||
        _gameBloc.type == GameType.BotHard) {
      if (_winner == Sign.O) {
        _message = "LOSE";
        _textStyle = _loseTextStyle;
      } else if (_winner == Sign.X) {
        _message = "WIN";
        _textStyle = _winTextStyle;
      } else {
        _message = "TIE";
        _textStyle = _winTextStyle;
      }
    } else {
      if (_winner == Sign.O) {
        _message = "O WIN";
        _textStyle = _winTextStyle;
      } else if (_winner == Sign.X) {
        _message = "X WIN";
        _textStyle = _winTextStyle;
      } else {
        _message = "TIE";
        _textStyle = _winTextStyle;
      }
    }
  }
}
