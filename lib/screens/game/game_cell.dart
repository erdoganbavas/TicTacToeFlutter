import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/bloc/bloc_provider.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/helpers/game_colors.dart';
import 'package:tictactoe/helpers/game_type.dart';
import 'package:tictactoe/helpers/sign.dart';
import 'package:tictactoe/helpers/size_helper.dart';

class GameCell extends StatefulWidget {
  final int x;
  final int y;

  const GameCell({Key key, this.x, this.y}) : super(key: key);

  @override
  _GameCellState createState() => _GameCellState();
}

class _GameCellState extends State<GameCell> {
  Sign _localSign = Sign.Empty;
  GameBloc _gameBloc;
  SizeHelper _sizeHelper;

  @override
  void initState() {
    super.initState();

    _gameBloc = BlocProvider.of(context);
    _sizeHelper = SizeHelper(context);

    _initListeners();
  }

  @override
  Widget build(BuildContext context) {
    // one sides' dimension of grid
    double side = _sizeHelper.gridSide();

    return Positioned(
      left: (widget.x * side / 3),
      top: (widget.y * side / 3),
      child: GestureDetector(
        // Let Tap event triggered on empty child
        behavior: HitTestBehavior.opaque,
        onTap: (){
          // only call for tap event if it's players' turn or it's a 2 player game
          if (_gameBloc.turn == Sign.X || _gameBloc.type == GameType.TwoPlayer){
            _onGameCellTap();
          }
        },
        child: SizedBox(
          width: side / 3,
          height: side / 3,
          child: GameCellSign(
            sign: _localSign,
          ),
        ),
      ),
    );
  }

  _initListeners() {
    // listen for bot plays/taps
    _gameBloc.bot.listen((data) {
      if (data["x"] == widget.x && data["y"] == widget.y) {
        _onGameCellTap();
      }
    });

    // listen for reset request
    _gameBloc.reset.listen((reset) {
      if (reset == true) {
        setState(() {
          _localSign = Sign.Empty;
        });
      }
    });
  }

  _onGameCellTap() {
    if (_gameBloc.boardTapLocked) {
      return;
    }

    Sign winner = _gameBloc.hasWinner(_gameBloc.grid); // check

    if (winner != Sign.Empty || _gameBloc.isTie()) {
      _gameBloc.snackBarMessage("Game is over! No more move");
    } else if (_localSign != Sign.Empty) {
      _gameBloc.snackBarMessage("Cell is not empty!");
    } else {
      setState(() {
        // set cell's sign to turn's sign
        _localSign = _gameBloc.turn;
      });

      if (_gameBloc.turn == Sign.X) {
        _gameBloc
          ..switchTurnO() // change global sign, whose turn sign
          ..fillCell(
            Sign.X,
            widget.x,
            widget.y,
          ); // fill the grid with tapped sign

      } else if (_gameBloc.turn == Sign.O) {
        _gameBloc
          ..switchTurnX() // change global sign, whose turn sign
          ..fillCell(
            Sign.O,
            widget.x,
            widget.y,
          ); // fill the grid with tapped sign

      } else {
        print("Unknown Sign");
        return;
      }

      // check if this is a winning move
      winner = _gameBloc.hasWinner(_gameBloc.grid);

      if (winner != Sign.Empty) {
        print("Winner " + winner.index.toString());
        _gameBloc.broadcastGameOver(winner);
        _gameBloc.addScore(winner);

      } else if (winner == Sign.Empty && _gameBloc.isTie()) {
        print("IT S A TIE");
        _gameBloc.broadcastGameOver(winner);
        _gameBloc.addScore(winner);

      } else if (_localSign == Sign.X &&
          (_gameBloc.type == GameType.BotEasy ||
              _gameBloc.type == GameType.BotHard)) {

        // give some time to BOT to play after player
        Timer(Duration(milliseconds: 1000), () {
          _gameBloc.tapForBot();
        });

      } else if (_gameBloc.type == GameType.TwoPlayer) {
        // 2 player game wait for other player
      }
    }
  }

}

class GameCellSign extends StatelessWidget {
  final Sign sign;

  const GameCellSign({Key key, this.sign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sign == Sign.O) {
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
    } else if (sign == Sign.X) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlareActor(
            'assets/Cross.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "cross",
            color: GameColors.SignX,
          ));
    } else {
      // No sign attached yet
      return Container(
        width: 150,
        height: 150,
      );
    }
  }
}
