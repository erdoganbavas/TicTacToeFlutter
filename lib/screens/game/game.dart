import 'package:flutter/material.dart';
import 'package:tictactoe/bloc/bloc_provider.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/helpers/game_colors.dart';
import 'package:tictactoe/helpers/game_type.dart';
import 'package:tictactoe/helpers/size_helper.dart';
import 'package:tictactoe/widgets/custom_snack_bar.dart';
import 'game_header.dart';
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

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  SizeHelper _sizeHelper;
  GameBloc _gameBloc;


  @override
  void initState() {
    super.initState();
    _sizeHelper = SizeHelper(context);
    _gameBloc = BlocProvider.of(context);

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: GameColors.MainBackground,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: _sizeHelper.headerVerticalPadding,
                ),
                child: SizedBox(
                  width: _sizeHelper.width,
                  height: _sizeHelper.headerHeight,
                  child: GameHeader(),
                ),
              ),
              SizedBox(
                width: _sizeHelper.width,
                height: _sizeHelper.bodyHeight(),
                child: GameArea(),
              ),
              SizedBox(
                width: _sizeHelper.width,
                height: _sizeHelper.footerHeight,
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
              ),
            ],
          ),
        ),
        CustomSnackBar(),
      ],
    );
  }
}