import 'package:flutter/material.dart';
import 'game_cell.dart';
import 'helpers/size_helper.dart';

class GameArea extends StatefulWidget {
  @override
  _GameAreaState createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> {
  @override
  Widget build(BuildContext context) {
    SizeHelper sizeHelper = SizeHelper(context);
    double side = sizeHelper.gridSide();

    return Padding(
      padding: sizeHelper.gridPadding(),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            left: (0.33 * side),
            child: SizedBox(
              width: sizeHelper.gridLineWidth,
              height: side,
              child: Container(
                color: Colors.blueAccent,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: (0.66 * side),
            child: SizedBox(
              width: sizeHelper.gridLineWidth,
              height: side,
              child: Container(
                color: Colors.blueAccent,
              ),
            ),
          ),
          Positioned(
            top: (0.33 * side),
            left: 0,
            child: SizedBox(
              width: side,
              height: sizeHelper.gridLineWidth,
              child: Container(
                color: Colors.blueAccent,
              ),
            ),
          ),
          Positioned(
            top: (0.66 * side),
            left: 0,
            child: SizedBox(
              width: side,
              height: sizeHelper.gridLineWidth,
              child: Container(
                color: Colors.blueAccent,
              ),
            ),
          ),
          GameCell(x: 0, y: 0),
          GameCell(x: 0, y: 1),
          GameCell(x: 0, y: 2),
          GameCell(x: 1, y: 0),
          GameCell(x: 1, y: 1),
          GameCell(x: 1, y: 2),
          GameCell(x: 2, y: 0),
          GameCell(x: 2, y: 1),
          GameCell(x: 2, y: 2),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
