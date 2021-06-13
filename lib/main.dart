/*
 * @Description: file
 * @Autor: dingyiming
 * @Date: 2021-06-14 06:19:29
 * @LastEditors: dingyiming
 * @LastEditTime: 2021-06-14 07:24:34
 */
import 'package:flutter/material.dart';
import 'package:hibi/page/welcome/WelcomePage.dart';
// import 'package:hibi/page/welcome/FlutterScreen.dart';

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter_ScreenUtil',
      theme: ThemeData(
        accentColor: ColorUtil.fromHex('#0a64bc'),
      ),
      home: WelcomePage(),
    );
  }
}

class ColorUtil {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
