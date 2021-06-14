import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'RiseFullButton.dart';

class MarketItemDrawerView extends StatefulWidget{
  final SymbolListData itemObject;

  const MarketItemDrawerView({Key key, this.itemObject}) : super(key: key);
  @override
  _State createState() => new _State();

}

class _State extends State<MarketItemDrawerView> {

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
  void didUpdateWidget(MarketItemDrawerView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.itemObject.close != oldWidget.itemObject.close){
      setState(() {
        isUpdate = true;
        Future.delayed(Duration(milliseconds: 200), (){
          setState(() {
            isUpdate = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SymbolListData itemObject = widget.itemObject;
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        InkWell(
          //splashColor: isRise(itemObject.change)?Config.greenColor.withOpacity(0.5):Config.redColor.withOpacity(0.5),
          onTap: (){
            Future.delayed(Duration(milliseconds: Config.delayedTime), (){
              Global.curretSymbol = itemObject.symbol;
              eventBus.fire(RefreshCurretSymbol());
              Navigator.of(context).pop();
            });
          },
          child: Column(
            children: <Widget>[
              Container(
                color: Global.curretSymbol == itemObject.symbol?Colours.dark_bg_gray_:Colours.dark_bg_gray,
                height: ScreenUtil().setHeight(88),
                padding:EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: itemObject.coinSymbol.toUpperCase(),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
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
                    Text(
                      itemObject.close.toString(),
                      style: TextStyle(color: CommonUtil.isRise(itemObject.chg)?Config.greenColor:Config.redColor,
                      fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),
                    )
                  ],
                )
              ),
            ],
          )),
/*
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
            Container()*/
      ],
    );
  }
}
