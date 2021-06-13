

import 'dart:math';

import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/styles/colors.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonUtil{

  static Color getTitleColor(BuildContext context){
    return isDark(context)?Colours.dark_textTitle:Colours.textTitle;
  }

  static Color getTextGreyColor(BuildContext context){
    return isDark(context)?Colours.dark_text_gray:Colours.text_gray;
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static bool isEmpty(String str){
    if(str == null){
      return true;
    }else{
      if(str == ''){
        return true;
      }else{
        return false;
      }
    }
  }

  static void showToast(String str){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff313E59).withOpacity(0.8),
        fontSize: 14.0
    );
  }


  static bool isRise(num change){
    if(change > 0){
      return true;
    }
    return false;
  }

  static String isRiseString(num change){
    if(change > 0){
      return '+';
    }
    return '';
  }


  static String formatTime(DateTime time){
    if(time == null){
      return '';
    }
    
    return time.year.toString()+'-'+pad(time.month.toString())+'-'+pad(time.day.toString())+' '+pad(time.hour.toString())+':'+pad(time.minute.toString());
  }

  static String formatTimeHHSSMM(DateTime time){
    if(time == null){
      return '';
    }

    return pad(time.hour.toString())+':'+pad(time.minute.toString())+':'+pad(time.second.toString());
  }
  
  static String pad(String obj){
    if(obj.length == 1){
      return '0'+obj;
    }else{
      return obj;
    }
  }

  static String genNum(){
    String alphabet = '1234567890';
    int strlenght = 8; /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }


  static SymbolObject renderSymbol(dataMap){
    SymbolObject symbolObject = new SymbolObject();
    symbolObject.volume = dataMap['volume'];
    symbolObject.change = dataMap['change'];
    symbolObject.baseUsdRate = dataMap['baseUsdRate'];
    symbolObject.chg = num.tryParse(formatNum(dataMap['chg']*100, 2));
    symbolObject.close = dataMap['close'];
    symbolObject.high = dataMap['high'];
    symbolObject.lastDayClose = dataMap['lastDayClose'];
    symbolObject.low = dataMap['low'];
    symbolObject.open = dataMap['open'];
    symbolObject.symbol = dataMap['symbol'];
    symbolObject.turnover = dataMap['turnover'];
    symbolObject.usdRate = dataMap['usdRate'];
    symbolObject.zone = dataMap['zone'];
    symbolObject.formName = dataMap['symbol'].split('/')[0];
    symbolObject.toName = dataMap['symbol'].split('/')[1];
    symbolObject.volumeStr = parseVolume(dataMap['volume']);
    return symbolObject;
  }

  //数字转k,m
  static String parseVolume(num value){
    var _formattedNumber = NumberFormat.compactCurrency(
      locale:'en',
      decimalDigits: 4,
      symbol: '',
    ).format(value);
    return _formattedNumber;
  }

  //数字转，
  static String parseStrNumber(num value){
    return value.toStringAsFixed(2).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }


  //转涨跌幅
  static String formatNum(num num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      return num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }else{
      return num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }
  }


  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String _renderCount(String price,int count){
    List<String> s = price.split('.');
    if(s.length > 1){
      if(s[1].length > 8){
        num p = num.tryParse(price);
        return p.toStringAsFixed(count);
      }
    }

    return price;
  }

  static String calcCny(num price,num meanCny){
    num finalPrice = price * meanCny;
    return finalPrice.toStringAsFixed(2);
  }

}