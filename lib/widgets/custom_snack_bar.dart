import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:tictactoe/bloc/bloc_provider.dart';

import 'package:tictactoe/bloc/game_bloc.dart';

class CustomSnackBar extends StatefulWidget {
  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();

}

class _CustomSnackBarState extends State<CustomSnackBar>
    with SingleTickerProviderStateMixin {
  String message = "";
  double height = 50;
  double intialBottomPosition = -75.0;
  double bottomPosition = -75.0;

  Animation<double> animation;
  AnimationController controller;
  GameBloc _gameBloc;

  void show(_message) {
    setState(() {
      message = _message;
      controller.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _gameBloc = BlocProvider.of(context);

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    animation =
        Tween<double>(begin: intialBottomPosition, end: 20).animate(controller)
          ..addListener(() {
            setState(() {
              bottomPosition = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Future.delayed(Duration(seconds: 2), () {
                controller.reverse();
              });
            }
          });

    _gameBloc.snackBar.listen((_message) {
      setState(() {
        message = _message;
        controller.forward();
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: [
      Positioned(
        bottom: bottomPosition,
        left: 0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              color: Colors.redAccent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 14
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
