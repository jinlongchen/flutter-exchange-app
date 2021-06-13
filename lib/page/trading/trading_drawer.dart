import 'package:hibi/common/Config.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/MarketItemDrawerView.dart';
import 'package:hibi/widget/MyUnderlineTabIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class TradingDrawer extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<TradingDrawer> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<String> pages = ['zixuan'.tr(),'USDT',];
  int curretIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pages.length, vsync: this);
    _tabController.animateTo(1);
    _tabController.addListener(() {
      switch(_tabController.index){
        case 0:
          setState(() {
            curretIndex = 0;
          });
          break;
        case 1:
          setState(() {
            curretIndex = 1;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(32),),
            child: Text('tab_bibi'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
          ),
          Container(
            child: TabBar(
              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(32)),
              labelColor: Color(0xFFE0E0E7),
              unselectedLabelColor: Color(0xFFE0E0E7).withOpacity(0.3),
              indicator: MyUnderlineTabIndicator(borderSide:  BorderSide(width: 2.0, color: Theme.of(context).accentColor)),
              controller: _tabController,
              isScrollable: true,
              tabs: pages.map((String title) {
                return Tab(
                  text: title,
                );
              }).toList(),
            ),
            alignment: Alignment.centerLeft,
          ),
          Consumer<SymbolState>(
            builder: (context,symbolState,child){
              List<SymbolListData> info ;
              if(curretIndex == 1){
                info = symbolState.symbol;
              }else{
                info = symbolState.getCollectSymbols();
              }
              return ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: new NeverScrollableScrollPhysics(),
                itemCount: info.length, //数据的数量
                itemBuilder: (BuildContext context,int index){
                  return MarketItemDrawerView(itemObject: info[index],);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
