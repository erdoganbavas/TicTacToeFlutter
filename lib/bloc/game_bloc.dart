import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/helpers/game_type.dart';
import 'package:tictactoe/helpers/sign.dart';

import 'bloc_provider.dart';

class GameBloc implements BlocBase {
  final GameType type;

  // 2 dimension list of signs on grid,
  // Couldn't use List.filled b/c grid[x][y] = sign fills all row with sign ??!!
  // List<List<Sign>> grid = List.filled(3, List.filled(3, Sign.Empty));
  List<List<Sign>> grid = [
    [Sign.Empty, Sign.Empty, Sign.Empty],
    [Sign.Empty, Sign.Empty, Sign.Empty],
    [Sign.Empty, Sign.Empty, Sign.Empty]
  ];

  bool boardTapLocked = false;

  GameBloc(this.type);

  // whose turn is it?
  Sign initialTurn = Sign.X; // Player / Bot is always O
  Sign turn = Sign.X; // whose turn

  StreamController<Map<String, Object>> _botController = StreamController<Map<String, Object>>.broadcast();
  Stream<Map<String, Object>> get bot => _botController.stream;

  StreamController<bool> _resetController = StreamController<bool>.broadcast();
  Stream<bool> get reset => _resetController.stream;

  StreamController<bool> _scoreUpdateController = StreamController<bool>.broadcast();
  Stream<bool> get scoreUpdate => _scoreUpdateController.stream;

  StreamController<String> _snackBarController = StreamController<String>.broadcast();
  Stream<String> get snackBar => _snackBarController.stream;

  StreamController<Sign> _gameOverController = StreamController<Sign>.broadcast();
  Stream<Sign> get gameOver => _gameOverController.stream;

  @override
  void dispose() {
    _botController.close();
    _resetController.close();
    _scoreUpdateController.close();
    _snackBarController.close();
    _gameOverController.close();
  }

  void tapForBot(){
    if(type == GameType.BotEasy){
      Map<String, int> emptyCell = _getRandomEmptyCell();

      _botController.sink.add({
        "x" : emptyCell["x"],
        "y" : emptyCell["y"],
        "sign" : Sign.O,
      });
    }else if(type == GameType.BotHard){
      Map<String, int> bestMove = _getSmartMove(grid, Sign.O);

      _botController.sink.add({
        "x" : bestMove["x"],
        "y" : bestMove["y"],
        "sign" : Sign.O,
      });
    }
  }

  // switch game turn to X
  void switchTurnX() {
    turn = Sign.X;
  }

  // switch game turn to O
  void switchTurnO() {
    turn = Sign.O;
  }

  // fills a grids position when tapped or bot played
  void fillCell(Sign sign, int x, int y){
    grid[x][y] = sign;
  }

  // return Sign of winner - Sign.Empty if no winner yet
  // check tie isTie()
  // TODO: return null on "no winner yet" return Sign.Empty on "isTie"
  Sign hasWinner(List<List<Sign>> winnerGrid){
    Sign winner = Sign.Empty;

    // winning sequences
    // vertical lines
    winnerGrid.forEach((row){
      if(row[0]==row[1] && row[0]==row[2] && row[0]!=Sign.Empty){
        winner = row[0];
      }
    });

    // horizontal lines
    for(int y=0; y<3; y++){
      if(winnerGrid[0][y]==winnerGrid[1][y] && winnerGrid[0][y]==winnerGrid[2][y] && winnerGrid[0][y]!=Sign.Empty){
        winner = winnerGrid[0][y];
      }
    }

    // crosses
    if(winnerGrid[0][0]==winnerGrid[1][1] && winnerGrid[0][0]==winnerGrid[2][2] && winnerGrid[0][0]!=Sign.Empty){
      winner = winnerGrid[0][0];
    }
    if(winnerGrid[0][2]==winnerGrid[1][1] && winnerGrid[0][2]==winnerGrid[2][0] && winnerGrid[0][2]!=Sign.Empty){
      winner = winnerGrid[0][2];
    }

    return winner;
  }

  // check if game is a Tie
  bool isTie(){
    bool draw = true;

    // check if grid is full
    grid.forEach((row){
      row.forEach((cell){
        if(cell==Sign.Empty){
          draw = false;
        }
      });
    });

    return draw;
  }

  // resets game board and values
  void resetGame() {
    // broadcast listeners to reset
    _resetController.sink.add(true);

    grid = [
      [Sign.Empty, Sign.Empty, Sign.Empty],
      [Sign.Empty, Sign.Empty, Sign.Empty],
      [Sign.Empty, Sign.Empty, Sign.Empty]
    ];

    switchTurnX();
  }

  // gets winning scores
  Future<Map<Sign, int>> getScores() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<Sign, int> scores = Map<Sign, int>();

    // get winning records according to game type
    scores[Sign.O] = prefs.getInt('score'+ Sign.O.toString() + type.toString()) ?? 0;
    scores[Sign.X] = prefs.getInt('score'+ Sign.X.toString() + type.toString()) ?? 0;
    scores[Sign.Empty] = prefs.getInt('score'+ Sign.Empty.toString() + type.toString()) ?? 0;

    return scores;
  }

  // sets a record for winning or a tie
  Future<void> addScore(Sign winner) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<Sign, int> scores = await this.getScores();

    prefs.setInt("score"+ winner.toString() + type.toString(), (scores[winner] + 1));
    _scoreUpdateController.sink.add(true);
  }

  void snackBarMessage(String message) {
    _snackBarController.sink.add(message);
  }

  // broadcasts game overs with winner
  void broadcastGameOver(Sign winner) {
    _gameOverController.sink.add(winner);
  }
  // returns list of empty cells
  List<Map<String, int>> _getEmptyCellCoords(List<List<Sign>> _grid){
    List<Map<String, int>> empty = new List<Map<String, int>>();
    int x = 0;
    int y = 0;

    _grid.forEach((row){
      y = 0;
      row.forEach((cell){
        if(cell==Sign.Empty){
          empty.add({"x": x, "y": y});
        }
        y++;
      });
      x++;
    });

    return empty;
  }

  // gets a random empty cell for bot easy mode
  Map<String, int> _getRandomEmptyCell() {
    List<Map<String, int>> empty = _getEmptyCellCoords(grid);
    Random random = new Random();

    return empty[random.nextInt(empty.length)];
  }

  // returns a possible move for bot hard mode
  // better than random by a couple if checks
  Map<String, int> _getSmartMove(List<List<Sign>> tempGrid, Sign _sign) {
    // get empty cells' coordinates
    List<Map<String, int>> availSpots = _getEmptyCellCoords(tempGrid);
    Sign winner;

    // loop empty cells
    for(int i=0; i<availSpots.length; i++){
      // check if Bot use this cell and win?
      tempGrid[availSpots[i]["x"]][availSpots[i]["y"]] = Sign.O;
      winner = hasWinner(tempGrid);
      if(winner == Sign.O){
        // then use this cell
        tempGrid[availSpots[i]["x"]][availSpots[i]["y"]] = Sign.Empty;
        return availSpots[i];
      }

      tempGrid[availSpots[i]["x"]][availSpots[i]["y"]] = Sign.Empty;
    }

    for(int i=0; i<availSpots.length; i++){
      // check if player use this cell and win?
      tempGrid[availSpots[i]["x"]][availSpots[i]["y"]] = Sign.X;
      winner = hasWinner(tempGrid);
      if(winner == Sign.X){
        // then use this cell
        tempGrid[availSpots[i]["x"]][availSpots[i]["y"]] = Sign.Empty;
        return availSpots[i];
      }

      tempGrid[availSpots[i]["x"]][availSpots[i]["y"]] = Sign.Empty;
    }

    // all empty cells doesn't end game return a random one
    Random random = new Random();
    return availSpots[random.nextInt(availSpots.length)];

  }
}
