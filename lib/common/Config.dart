import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Config{
  static bool isDebug = true;

  static int VERSION_CODE = 8;

  static num delayedTime = 140;
  static num vibrateTime = 30;
  static num vibrateAmp = 800;
  static const String theme = 'AppTheme';
  static const String token = 'token';
  static const String isFirst = 'isFirst';


  //static Color mainColor = Color(0xff0a2c48);
  //static Color backgroundColor = Color(0xff09141e);
  //static Color blackColor = Color(0xff030f19);
  //static Color mainColorMore = Color(0xff0a1d2b);
  //static Color mainColorLess = Color(0xff0f2234);
  static Color accentColor = Color(0xff00bd70);

  static Color greenColorLess = Color(0xffbaf754);
  static Color greenColor = Color(0xff17D7AB);
  static Color redColorLess = Color(0xffd73a65);
  static Color redColor = Color(0xFFEE6588);

  static Color textGrey = Color(0xff919191);
  static Color greyColor = Color(0xff919191);

  static Color text3A = Color(0xff759fc5);
  static Color EOEOEO = Color(0xffE0E0E0);
  static Color ECECEC = Color(0xffECECEC);


  static num size_BIG = ScreenUtil().setSp(38);
}