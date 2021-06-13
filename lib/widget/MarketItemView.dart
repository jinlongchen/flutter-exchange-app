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

class MarketItemView extends StatefulWidget{
  final SymbolListData itemObject;

  const MarketItemView({Key key, this.itemObject}) : super(key: key);
  @override
  _State createState() => new _State();

}

class _State extends State<MarketItemView> {

  bool isUpdate = false;

  String isRiseString(num change){
    if(change > 0){
      return '+';
    }
    return '';
  }
  bool isRise(num change){
    if(change > 0){
      return true;
    }
    return false;
  }

  @override
  void didUpdateWidget(MarketItemView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    /*if(widget.itemObject.close != oldWidget.itemObject.close){
      setState(() {
        isUpdate = true;
        Future.delayed(Duration(milliseconds: 200), (){
          setState(() {
            isUpdate = false;
          });
        });
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    SymbolListData itemObject = widget.itemObject;
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        InkWell(
          //splashColor: isRise(itemObject.change)?Config.greenColor.withOpacity(0.5):Config.redColor.withOpacity(0.5),
          onTap: () async {
            if (await Vibration.hasCustomVibrationsSupport() && Platform.isAndroid) {
              Vibration.vibrate(duration: Config.vibrateTime, amplitude: Config.vibrateAmp);
            }
            Future.delayed(Duration(milliseconds: Config.delayedTime), (){
              Global.curretSymbol = itemObject.symbol;
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return KLinePage();
              }));
            });
          },
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(156),
                padding:EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: itemObject.infolink,
                            width: ScreenUtil().setWidth(76),height: ScreenUtil().setWidth(76),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                              child: Column(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: itemObject.coinSymbol.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(32),
                                              color: Colours.dark_text_gray,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Din'
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' /'+itemObject.baseSymbol.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(24),
                                              color: Color(0xFF5F626D),
                                              fontFamily: 'Din'
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    child: Text("24hvolume".tr()+' '+CommonUtil.parseVolume(itemObject.volume),style: TextStyle(
                                        fontSize: ScreenUtil().setSp(24),
                                        color: Color(0xFF5F626D),
                                        fontFamily: 'Din'
                                    )),
                                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              )
                          ),
                        ],
                      )
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(itemObject.close.toString()+'',style: TextStyle(
                                  fontSize: ScreenUtil().setSp(32),
                                  color: Colours.dark_text_gray,
                                  fontFamily: 'Din',
                                  fontWeight: FontWeight.bold
                              )),
                              Padding(
                                child: Text('¥ '+CommonUtil.calcCny(itemObject.close, itemObject.priceCNY)+'',style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    color: Color(0xFF9496A2),
                                    fontFamily: 'Din',
                                    fontWeight: FontWeight.bold
                                )),
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                              )
                            ],
                          )
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: RiseFullButton(isRise: isRise(itemObject.chg),text: isRiseString(itemObject.chg)+CommonUtil.formatNum(widget.itemObject.chg*100, 2)+'%',),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                color:  CommonUtil.isDark(context)?Colours.dark_line : Colours.line,
              )
            ],
          )),

        isUpdate?
        Container(
          width: ScreenUtil().setWidth(500),
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [isRise(itemObject.change)?Config.greenColor.withOpacity(0.2):Config.redColor.withOpacity(0.2),isRise(itemObject.change)?Config.greenColor.withOpacity(0.2):Config.redColor.withOpacity(0.2)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              )),
        ):
            Container()
      ],
    );
  }
}
