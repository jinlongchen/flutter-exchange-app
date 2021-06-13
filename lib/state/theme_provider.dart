import 'dart:ui';

import 'package:hibi/common/Config.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => ['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  
  void syncTheme() {
    final String theme = SpUtil.getString(Config.theme);
    if (theme.isNotEmpty && theme != ThemeMode.system.value) {
      notifyListeners();
    }
  }

  void setTheme(ThemeMode themeMode) {
    SpUtil.putString(Config.theme, themeMode.value);
    notifyListeners();
  }

  ThemeMode getThemeMode(){
    final String theme = SpUtil.getString(Config.theme);
    switch(theme) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      default:
        return ThemeMode.dark;
    }
  }

  ThemeData getTheme({bool isDarkMode = false}) {
    return ThemeData(
      errorColor: isDarkMode ? Colours.dark_red : Colours.red,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      accentColor: isDarkMode ? Colours.dark_accent_color : Colours.accent_color,
      bottomAppBarColor:isDarkMode ? Colours.dark_bootomBar_color:Colours.bootomBar_color,
      // Tab指示器颜色
      indicatorColor: isDarkMode ? Colours.dark_accent_color : Colours.app_main,
      // 页面背景色
      scaffoldBackgroundColor: isDarkMode ? Colours.dark_bg_color : Colors.white,
      // 主要用于Material背景色
      canvasColor: isDarkMode ? Colours.dark_bg_gray : Colors.white,
      // 文字选择色（输入框复制粘贴菜单）
      textSelectionColor: Colours.app_main.withAlpha(70),
      textSelectionHandleColor: Colours.app_main,
      textTheme: TextTheme(
        // TextField输入文字颜色
        subtitle1: isDarkMode ? TextStyles.textDark : TextStyles.text,
        // Text文字样式
        bodyText2: isDarkMode ? TextStyles.textDark : TextStyles.text,
        subtitle2: isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
        enabledBorder: new UnderlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colours.dark_unselected_item_color : Colours.unselected_item_color,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 4.0,
        color: isDarkMode ? Colours.dark_appBar_color : Colours.appBar_color,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      dividerTheme: DividerThemeData(
        color: isDarkMode ? Colours.dark_line : Colours.line,
        space: 0.6,
        thickness: 0.6
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      splashFactory:InkRipple.splashFactory,
      cardColor: isDarkMode ? Colours.dark_bg_gray : Colours.bg_gray,
      buttonColor: isDarkMode ? Colours.dark_accent_color : Colours.accent_color,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colours.dark_bg_gray,
        elevation: 4.0,
          actionTextColor:Colours.dark_accent_color,
          contentTextStyle:TextStyle(color: Colors.white)
      )
    );
  }

}