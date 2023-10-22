import 'package:flutter/material.dart';

class Style {
  /// Colors palette
  static const Color primary=Color(0xFF263171); //#263171 p
  static const Color primaryLight=Color(0xFF3862c8); //#3862c8 p2
  static const Color second=Color(0xFF9aa1cb); //#9aa1cb p3
  static const Color secondLight=Color(0xFFcbcedf); //#cbcedf p4
  static const Color clair=Color(0xFFe0e8fd);//#e0e8fd
  static const Color blackColor = Color(0xFF292930); // #292930 black
  static const Color whiteColor = Color(0xFFFFFFFF); //white

  static const Color marron = Color(0xFF154c79);

  ///title text style
  static Widget titleText(String txt,Color col,double size){
    return Text(txt,textAlign: TextAlign.start,style:TextStyle(color: col,fontSize: size, fontStyle:FontStyle.normal,fontWeight:FontWeight.bold,fontFamily: 'Red Ring'),);
  }


  ///sous title text style
  static Widget sousTitleText(String txt,Color col,double size){
    return Text(txt,style:TextStyle(color: col,fontSize: size, fontStyle: FontStyle.normal,fontFamily: 'Mark-Light'),);
  }
}