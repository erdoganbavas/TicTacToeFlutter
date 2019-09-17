import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'bloc/bloc_provider.dart';
import 'game_bloc.dart';
import 'game_header.dart';
import 'helpers/game_colors.dart';
import 'helpers/game_type.dart';
import 'helpers/size_helper.dart';
import 'game_area.dart';

class GamePage extends StatelessWidget {
  final GameType type;

  const GamePage({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: GameBloc(type),
      child: Game(),
    );
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    SizeHelper sizeHelper = SizeHelper(context);
    GameBloc _gameBloc = BlocProvider.of(context);


    // TODO: Show Winner / Loser popup
    return Stack(
      children: [
        Container(
          color: GameColors.MainBackground,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: sizeHelper.headerVerticalPadding,
                ),
                child: SizedBox(
                  width: sizeHelper.width,
                  height: sizeHelper.headerHeight,
                  child: GameHeader(),
                ),
              ),
              SizedBox(
                width: sizeHelper.width,
                height: sizeHelper.bodyHeight(),
                child: GameArea(),
              ),
              SizedBox(
                width: sizeHelper.width,
                height: sizeHelper.footerHeight,
                child: Center(
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.grey[300],
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      tooltip: 'Restart',
                      onPressed: () {
                        _gameBloc.resetGame();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
