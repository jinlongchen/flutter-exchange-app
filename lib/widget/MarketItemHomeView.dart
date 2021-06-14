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
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibration/vibration.dart';

import 'RiseFullButton.dart';

class MarketItemHomeView extends StatefulWidget{
  final SymbolListData itemObject;

  const MarketItemHomeView({Key key, this.itemObject}) : super(key: key);
  @override
  _State createState() => new _State();

}

class _State extends State<MarketItemHomeView> {

  Widget _buildLine(){
    List<BarChartGroupData> datas = [];
    double maxValue = 0;
    double minValue = 999999;
    for(double value in widget.itemObject.trend){
      if(value > maxValue){
        maxValue = value;
      }
      if(value < minValue){
        minValue = value;
      }
    }

    double heightOne;
    if(maxValue == minValue){
      heightOne = 33/1;
    }else{
      heightOne = 33/(maxValue - minValue);
    }

    for(int i = 0;i<widget.itemObject.trend.length;i++){
      num price = widget.itemObject.trend[i] - minValue;
      datas.add(BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(y:ScreenUtil().setHeight(15)+ScreenUtil().setHeight(price * heightOne), color: CommonUtil.isRise(widget.itemObject.chg)?Config.greenColor:Config.redColor,width: ScreenUtil().setWidth(4))],
          showingTooltipIndicators: [0]));
    }
    return AspectRatio(
      aspectRatio: 0.7,
      child: Container(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colours.dark_bg_gray_,
          child: BarChart(
            BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: ScreenUtil().setHeight(48),
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipBottomMargin: 8,
                    getTooltipItem: (_a, _b, _c, _d) => null,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: datas
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(48),top: ScreenUtil().setHeight(48)),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.dark_bg_gray,
      width: double.infinity,
      height: ScreenUtil().setHeight(184),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),bottom: ScreenUtil().setHeight(40)),
      child:GestureDetector(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colours.dark_bg_gray_,
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))
          ),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.itemObject.infolink,
                      width: ScreenUtil().setWidth(76),height: ScreenUtil().setWidth(76),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(widget.itemObject.coinSymbol+"/"+widget.itemObject.baseSymbol,style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                              Padding(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                                child:Text(CommonUtil.formatNum(widget.itemObject.chg*100, 2)+"%",style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.4),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                              ),
                              Image.asset(CommonUtil.isRise(widget.itemObject.chg)?'res/chg_up.png':'res/chg_down.png',width: ScreenUtil().setWidth(10),height: ScreenUtil().setWidth(6),),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                            child: Text(CommonUtil.parseVolume(widget.itemObject.volume),style: TextStyle(color:Colours.dark_text_gray.withOpacity(0.4),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              _buildLine()
            ],
          ),
        ),
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (await Vibration.hasCustomVibrationsSupport() && Platform.isAndroid) {
            Vibration.vibrate(duration: Config.vibrateTime, amplitude: Config.vibrateAmp);
          }
          Global.curretSymbol = widget.itemObject.symbol;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return KLinePage();
          }));
        },
      )
    );
  }
}
