import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'bloc/bloc_provider.dart';
import 'game_bloc.dart';
import 'helpers/game_colors.dart';
import 'helpers/game_type.dart';
import 'helpers/sign.dart';
import 'helpers/size_helper.dart';

class GameCell extends StatefulWidget {
  final int x;
  final int y;

  const GameCell({Key key, this.x, this.y}) : super(key: key);

  @override
  _GameCellState createState() => _GameCellState();
}

class _GameCellState extends State<GameCell> {
  Sign _globalSign = Sign.X;
  Sign _localSign = Sign.Empty;
  GameBloc _gameBloc;

  void onGameCellTap(){
    Sign winner = _gameBloc.hasWinner(_gameBloc.grid); // check

    print(_gameBloc.grid.toString());
    if(winner != Sign.Empty  || _gameBloc.isDraw()){
      print("Game is over! No more move");
    }else if(_localSign != Sign.Empty){
      print("Cell is already tapped " + widget.x.toString() + " " + widget.y.toString());
    }else{
      print(widget.x.toString() + " " + widget.y.toString() + " tapped");

      setState(() {
        _localSign = _globalSign; // (_globalSign == Sign.X)?Sign.O:Sign.X;
      });

      if (_globalSign == Sign.X) {
        _gameBloc
          ..turnO() // change global sign, whose turn sign
          ..fillCell(Sign.X, widget.x, widget.y); // fill the grid

      } else if (_globalSign == Sign.O) {
        _gameBloc
          ..turnX() // change global sign, whose turn sign
          ..fillCell(Sign.O, widget.x, widget.y); // fill the grid

      } else {
        print("Unknown Sign");
        return;
      }

      winner = _gameBloc.hasWinner(_gameBloc.grid);
      if(winner != Sign.Empty) {
        print("Winner " + winner.index.toString());
        _gameBloc.addScore(winner);
      }else if(winner == Sign.Empty && _gameBloc.isDraw()){
        print("IT S A TIE");
        _gameBloc.addScore(winner);
      }else if(_localSign == Sign.X && (_gameBloc.type==GameType.BotEasy || _gameBloc.type==GameType.BotHard) ){
        print("tapForBot() timer başladı");
        Timer(Duration(milliseconds: 500), (){
          _gameBloc.tapForBot();
        });
      }else if(_gameBloc.type==GameType.TwoPlayer) {
        // 2 player game wait for other player
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _gameBloc = BlocProvider.of(context);
    final SizeHelper sizeHelper = SizeHelper(context);

    double side = sizeHelper.gridSide();

    // listen global sign from Bloc to get whose turn is it
    _gameBloc.turn.listen((data) {
      _globalSign = data;
    });

    // listen for bot plays/taps
    _gameBloc.bot.listen((data){
      if(data["x"]==widget.x && data["y"]==widget.y){
        onGameCellTap();
      }
    });

    // listen for reset request
    _gameBloc.reset.listen((reset){
      if(reset == true) {
        setState((){
          _localSign = Sign.Empty;
        });
      }
    });

    return Positioned(
      left: (widget.x * side / 3),
      top: (widget.y * side / 3),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Let Tap event triggered on empty child
          onTap: onGameCellTap,
          child: SizedBox(
              width: side / 3,
              height: side / 3,
              child: GameCellSign(sign: _localSign,)
          )
      ),
    );
  }
}

class GameCellSign extends StatelessWidget {
  final Sign sign;

  const GameCellSign({Key key, this.sign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(sign == Sign.O){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlareActor(
          'assets/Circle.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "circle",
          color: GameColors.SignO,
        ),
      );
    }else if(sign == Sign.X){
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlareActor(
            'assets/Cross.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "cross",
            color: GameColors.SignX,
          )
      );
    }else{
      // No sign attached yet
      return Container(
        width: 150,
        height: 150,
      );
    }
  }
}