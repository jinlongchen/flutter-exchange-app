import 'dart:io';

import 'package:hibi/common/Config.dart';
import 'package:hibi/page/LoadingPage.dart';
import 'package:hibi/page/MainPage.dart';
import 'package:hibi/page/user/LoginPage.dart';
import 'package:hibi/page/welcome/WelcomePage.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/state/TreatyState.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/state/theme_provider.dart';
import 'package:hibi/widget/CustomNavigatorObserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sp_util/sp_util.dart';

import 'common/CommonUtil.dart';
import 'common/Global.dart';

main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SpUtil.getInstance();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  while(Platform.localeName == null){
    await Future.delayed(const Duration(microseconds: 600), (){});
  }

  if (Platform.isAndroid) {
    final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(MultiProvider(
    providers:[
      ChangeNotifierProvider(create: (context)=>SymbolState()),
      ChangeNotifierProvider(create: (context)=>ThemeProvider()),
      ChangeNotifierProvider(create: (context)=>UserInfoState()),
      ChangeNotifierProvider(create: (context)=>TreatyState()),
    ],
    child: EasyLocalization(
        supportedLocales: [Locale('zh'),Locale('en'),Locale('vi'),Locale('zh','TW')],
        path: 'i18n', // <-- change patch to your
        fallbackLocale: Locale('zh'),
        child: MyApp()
    ),
  ));}

class MyApp extends StatelessWidget {

  Future<void> saveLocale(String code) async {
    Global.language = code;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(CommonUtil.isEmpty(prefs.getString('language'))){
      prefs.setString('language', code);
    }
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (_,provider,__){
          return MaterialApp(
            navigatorKey: Global.navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            localeListResolutionCallback: (deviceLocale, supportedLocales) {
              saveLocale(deviceLocale[0].languageCode);
            },
            debugShowCheckedModeBanner: false,
            theme: provider.getTheme(),
            darkTheme: provider.getTheme(isDarkMode: true),
            themeMode: provider.getThemeMode(),
            home: LoadingPage(),
            routes: <String, WidgetBuilder>{
              "/Loading":(BuildContext context) => new LoadingPage(),
              "/Main":(BuildContext context) => new MainPage(),
              "/Login":(BuildContext context) => new LoginPage(),
              "/Welcome":(BuildContext context) => new WelcomePage(),
            },
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget,
              );
            },
          );
        },
      ),
    );
  }
}

