

import 'package:hibi/model/banner_entity.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:flutter/widgets.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorKey=GlobalKey();
  static String language = 'zh';
  static List<MoneyListDataData> assetsList = [];
  static List<BannerData> bannerList = [];
  static List<dynamic> notices = [];
  static dynamic flowtypes = null;

  static String curretSymbol = 'BBT_USDT';
  static String curretTreaty = 'ETH_USD';
}