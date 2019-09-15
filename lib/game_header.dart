import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc_provider.dart';
import 'game_bloc.dart';
import 'helpers/game_colors.dart';
import 'helpers/sign.dart';
import 'helpers/size_helper.dart';


class GameHeader extends StatefulWidget {
  @override
  _GameHeaderState createState() => _GameHeaderState();
}

class _GameHeaderState extends State<GameHeader> {
  Map<Sign, int> _scores = Map<Sign, int>();
  GameBloc _gameBloc;

  @override
  Widget build(BuildContext context) {
    SizeHelper sizeHelper = SizeHelper(context);
    _gameBloc = BlocProvider.of(context);

    _gameBloc.getScores().then((scores)=>setState((){
      _scores = scores;
    }));

    _gameBloc.scoreUpdate.listen((scoreUpdate){
      if(scoreUpdate == true) {
        _gameBloc.getScores().then((scores)=>setState((){
          _scores = scores;
        }));
      }
    });

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: sizeHelper.headerHeight / 3,
                  height: sizeHelper.headerHeight / 3,
                  child: FlareActor(
                    'assets/Circle.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    color: GameColors.SignO,
                  ),
                ),
              ),
              Text(
                _scores[Sign.O].toString(),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black26,
                    decoration: TextDecoration.none
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("D",
                    style: TextStyle(
                        fontSize: sizeHelper.headerHeight / 3,
                        color: Colors.black45,
                        decoration: TextDecoration.none
                    )
                ),
              ),
              Text(
                _scores[Sign.Empty].toString(),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black26,
                    decoration: TextDecoration.none
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: sizeHelper.headerHeight / 3,
                  height: sizeHelper.headerHeight / 3,
                  child: FlareActor(
                    'assets/Cross.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    color: GameColors.SignX,
                  ),
                ),
              ),
              Text(
                _scores[Sign.X].toString(),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black26,
                    decoration: TextDecoration.none
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
