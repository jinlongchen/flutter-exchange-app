import 'dart:convert';
import 'dart:io';
import 'package:hibi/common/Config.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/MarketItem.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/model/treaty_list_entity.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/state/TreatyState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/MarketItemTreatyView.dart';
import 'package:hibi/widget/MarketItemView.dart';
import 'package:hibi/widget/RiseFullButton.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MarketTreatyPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MarketTreatyPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<ItemObject> list = [];

  final String type = 'usdt';
  int sortPrice = 0;
  int sortChange = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  Widget _renderStatusSort(String type){
    if(type == 'price'){
      if(sortPrice == 0){
        return Image.asset('res/sort.png',width: ScreenUtil().setWidth(16),height: ScreenUtil().setHeight(16),);
      }else if(sortPrice == 1){
        return Image.asset('res/sort_up.png',width: ScreenUtil().setWidth(16),height: ScreenUtil().setHeight(16),);
      }else if(sortPrice == 2){
        return Image.asset('res/sort_down.png',width: ScreenUtil().setWidth(16),height: ScreenUtil().setHeight(16),);
      }
    }
    if(type == 'change'){
      if(sortChange == 0){
        return Image.asset('res/sort.png',width: ScreenUtil().setWidth(16),height: ScreenUtil().setHeight(16),);
      }else if(sortChange == 1){
        return Image.asset('res/sort_up.png',width: ScreenUtil().setWidth(16),height: ScreenUtil().setHeight(16),);
      }else if(sortChange == 2){
        return Image.asset('res/sort_down.png',width: ScreenUtil().setWidth(16),height: ScreenUtil().setHeight(16),);
      }
    }
  }

  void sort(String type){
    print(type);
    if(type == 'price'){
      sortChange = 0;
      if(sortPrice == 0){
        sortPrice = 1;
      }else if(sortPrice == 1){
        sortPrice = 2;
      }else if(sortPrice == 2){
        sortPrice = 0;
      }
    }
    if(type == 'change'){
      sortPrice = 0;
      if(sortChange == 0){
        sortChange = 1;
      }else if(sortChange == 1){
        sortChange = 2;
      }else if(sortChange == 2){
        sortChange = 0;
      }
    }
    setState(() {

    });
    //makeData(list);
  }

  Widget _renderItem(dynamic object){
    return MarketItemTreatyView(itemObject: object,);
  }

  Widget getStatusView(){
    return(
        Container(
          margin: EdgeInsets.only(top: 10),
          color: Colours.dark_bg_gray,
          height: ScreenUtil().setHeight(60),
          padding:EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
          child:Row(
            children: <Widget>[
              Expanded(
                flex:3,
                child: Container(
                  child: Text('symbol'.tr(),style: TextStyle(color: Colors.white38,fontSize: ScreenUtil().setSp(22)),),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: (){
                      sort('price');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('price_new'.tr(),style: TextStyle(color: Colors.white38,fontSize: ScreenUtil().setSp(22)),),
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                          child:_renderStatusSort("price"),
                        )
                      ],
                    ),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: (){ sort("change");},
                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('price_change'.tr(),style: TextStyle(color: Colors.white38,fontSize: ScreenUtil().setSp(22)),),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                              child:_renderStatusSort("change"),
                            )
                          ],
                        )
                    ),
                  )
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Container(
            child:CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                new SliverPadding(
                  padding: EdgeInsets.only(top:ScreenUtil().setHeight(0),bottom: ScreenUtil().setHeight(50)),
                  sliver: new SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        getStatusView(),
                        Consumer<TreatyState>(
                          builder: (context,symbolState,child){
                            List<TreatyListData> info = symbolState.symbol;
                            if(sortPrice == 1){
                              info.sort((left,right)=>right.close.compareTo(left.close));
                            }else if(sortPrice == 2){
                              info.sort((left,right)=>left.close.compareTo(right.close));
                            }
                            if(sortChange == 1){
                              info.sort((left,right)=>right.chg.compareTo(left.chg));
                            }else if(sortChange == 2){
                              info.sort((left,right)=>left.chg.compareTo(right.chg));
                            }
                            return ListView.builder(
                              padding: EdgeInsets.only(top: 0),
                              shrinkWrap: true,
                              physics: new NeverScrollableScrollPhysics(),
                              itemCount: symbolState.symbolLength, //数据的数量
                              itemBuilder: (BuildContext context,int index){
                                return _renderItem(info[index]);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ))
    );
  }
}
