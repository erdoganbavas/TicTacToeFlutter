import 'package:flutter/material.dart';

class SizeHelper{
  final BuildContext context;

  double width;
  double height;

  double headerHeight = 100.0;
  double headerVerticalPadding = 30.0;
  double footerHeight = 100.0;
  double footerVerticalPadding = 10.0;

  double gridLineWidth = 2.0;

  double gridAreaRatio = 0.8;
  double _gridSideMinPadding = 5;

  // Singleton
  static SizeHelper _instance;

  factory SizeHelper(BuildContext context){
    if(SizeHelper._instance == null){
      SizeHelper._instance = SizeHelper._internal(context);
    }

    return SizeHelper._instance;
  }

  SizeHelper._internal(this.context){
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  bodyHeight(){
    return height - (headerHeight + (2*headerVerticalPadding) + footerHeight + footerVerticalPadding);
  }

  // Grid is a square, here we return one side's size
  gridSide(){
    // width or height, get smaller one
    double baseWidth = 0.0;

    if(bodyHeight() > width){
      baseWidth = width - _gridSideMinPadding;
    }else{
      baseWidth = bodyHeight() - _gridSideMinPadding;
    }


    return baseWidth;
  }

  gridPadding(){
    EdgeInsets padding;

    if(bodyHeight() > width){
      padding = EdgeInsets.symmetric(vertical: (bodyHeight()-width)/2, horizontal: _gridSideMinPadding);
    }else{
      padding = EdgeInsets.symmetric(vertical: _gridSideMinPadding, horizontal: (width-bodyHeight())/2);
    }

    return padding;
  }

}