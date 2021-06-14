import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/page/trading/KLinePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibration/vibration.dart';
import 'package:easy_localization/easy_localization.dart';

import 'RiseFullButton.dart';

class PyramidItem extends StatefulWidget{
  final bool isSelected;
  final bool isActived;
  final String title;
  final String value;

  const PyramidItem({Key key, this.isSelected=false, this.isActived=true, this.title, this.value}) : super(key: key);
  @override
  _State createState() => new _State();

}

class _State extends State<PyramidItem> {


  TextStyle tvTitle = TextStyle(color: Colors.white.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din');
  TextStyle tvValue = TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(29),fontFamily: 'Din');
  TextStyle tvValueNormal = TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(29),fontFamily: 'Din');

  TextStyle tvTitleGrey = TextStyle(color: Colours.dark_text_gray.withOpacity(0.2),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din');
  TextStyle tvValueGrey = TextStyle(color: Colours.dark_text_gray.withOpacity(0.2),fontSize: ScreenUtil().setSp(29),fontFamily: 'Din');

  @override
  Widget build(BuildContext context) {
    if(!widget.isActived){
      return Stack(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(214),
            height: ScreenUtil().setHeight(114),
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            decoration: BoxDecoration(
              color: Color(0xff1D2942),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(widget.title,style: tvTitleGrey,),
                Padding(
                  child:Text(widget.value+' BBT',style: tvValueGrey,),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset('res/pyramid_unactive.png',width: ScreenUtil().setWidth(79),height: ScreenUtil().setWidth(76),fit: BoxFit.fill,)
          )
        ],
      );
    }
    return Container(
      width: ScreenUtil().setWidth(214),
      height: ScreenUtil().setHeight(114),
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
      decoration: BoxDecoration(
        color: widget.isSelected?Colours.dark_accent_color:Colours.dark_bg_gray_,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: widget.isSelected?Border.all(width: 0):Border.all(color:Color(0xff2C3A5A),width: 1)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(widget.title,style: tvTitle,),
          Padding(
            child:Text(widget.value+' BBT',style: widget.isSelected?tvValue:tvValueNormal,),
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
          )
        ],
      ),
    );
  }
}
