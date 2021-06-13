import 'dart:async';
import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/money_all_entity.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/model/wallet_entity.dart';
import 'package:hibi/page/money/AssetsDepositPage.dart';
import 'package:hibi/page/money/AssetsDetailBBTPage.dart';
import 'package:hibi/page/money/AssetsRecordPage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vibration/vibration.dart';

import 'AssetsDetailPage.dart';
import 'AssetsWithdrawPage.dart';
import 'ChangePage.dart';

class MoneyPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MoneyPage> with SingleTickerProviderStateMixin {


  String allUsd = "0.0";
  String allCny = "0.0";
  String allUsdLabel = "********";
  String allCnyLabel = "********";
  bool showRealAssets = true;
  bool hideZeroAssets = false;

  List<MoneyListDataData> list = [];
  List<MoneyListDataData> listHave = [];

  StreamSubscription  _sub;


  @override
  void initState() {
    super.initState();
    getData();
    _sub = eventBus.on<RefreshAsstes>().listen((event) {
      getData();
    });
  }


  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<void> getData(){
    String type = "BIBI";
    var param = {'walletType':type};
    DioManager.getInstance().post(Url.PROPERTY, param, (data){
      MoneyListEntity moneyListEntity = JsonConvert.fromJsonAsT(data);
      List<MoneyListDataData> moneyListHave = [];
      for(MoneyListDataData item in moneyListEntity.data.data){
        if(item.totalSum > 0){
          moneyListHave.add(item);
        }
      }
      setState(() {
        list = moneyListEntity.data.data;
        listHave = moneyListHave;
        Global.assetsList = moneyListEntity.data.data;
        allUsd = moneyListEntity.data.usdTotalSum.toString();
        allCny = moneyListEntity.data.cnyTotalSum.toString();
      });
      return true;
    }, (error){
      CommonUtil.showToast(error);
      return true;
    });
  }

  Widget _buildBtnAssets(String title,Function onClick){
    return GestureDetector(
      child: Container(
        width: ScreenUtil().setWidth(192),
        height: ScreenUtil().setHeight(64),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12)),
        ),
        child: Center(
          child: Text(
            title,style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600),
          ),
        ),
      ),
      onTap: (){
        onClick();
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  Widget _buildAssetCard(){
    return Card(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),bottom: ScreenUtil().setHeight(66)),
      elevation: 6.0,  //设置阴影
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),  //设置圆角
      child: Container(
        height: ScreenUtil().setHeight(366),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("res/bg_total_assets_card.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                  child: Row(
                    children: <Widget>[
                      Text('assets_zzczh'.tr(),style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),),
                      GestureDetector(
                        child:  Padding(
                          child: Image.asset(showRealAssets?'res/eye_open.png':'res/eye_close.png',width: ScreenUtil().setWidth(30),height: ScreenUtil().setWidth(30),),
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        ),
                        onTap: (){
                          setState(() {
                            showRealAssets = !showRealAssets;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                  child: Text((showRealAssets?allUsd.toString():allUsdLabel)+' USDT',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(48),fontFamily:'Din',fontWeight:FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                  child: Text('≈'+(showRealAssets?allCny.toString():allCnyLabel)+' CNY',style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: ScreenUtil().setSp(24),fontFamily:'Din',)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildBtnAssets('assets_cb'.tr(),(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return AssetsDepositPage();
                        }));
                      }),
                      _buildBtnAssets('assets_tb'.tr(),(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return AssetsWithdrawPage();
                        }));
                      }),
                      _buildBtnAssets('assets_hz'.tr(),(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ChangePage();
                        }));
                      })
                    ],
                  ),
                )
              ],
            )
        ),
      )
    );
  }

  Widget _renderItem(int index){
    MoneyListDataData item ;
    if(hideZeroAssets){
      item = listHave[index];
    }else{
      item = list[index];
    }
    return Stack(
      children: <Widget>[
        Card(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
            ),
            child: Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                decoration: BoxDecoration(
                    color: Colours.dark_bg_gray_,
                    borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CachedNetworkImage(imageUrl: item.coin.infolink,width: ScreenUtil().setWidth(64),height: ScreenUtil().setWidth(64),),
                          Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                        ],
                      ),
                    ),
                    Expanded(
                      flex:2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                              child:Text(item.coin.name,style: TextStyle(color: Color(0xffECAE03),fontSize: ScreenUtil().setSp(28),fontFamily:'Din',fontWeight:FontWeight.bold),)
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                              child:Text(item.totalSum.toString(),maxLines:1,style: TextStyle(color: CommonUtil.getTextGreyColor(context),fontSize: ScreenUtil().setSp(36),fontFamily:'Din',fontWeight:FontWeight.bold))
                          )
                        ],
                      ),
                    )
                  ],
                )
            )
        ),
        new Positioned.fill(
            child:  Material(
                color: Colors.transparent,
                child:  Container(
                  padding: EdgeInsets.all(2),
                  child: InkWell(
                      onTap: () async {
                        if (await Vibration.hasCustomVibrationsSupport() && Platform.isAndroid) {
                          Vibration.vibrate(duration: Config.vibrateTime, amplitude: Config.vibrateAmp);
                        }
                        Future.delayed(Duration(milliseconds: Config.delayedTime),(){if(item.coin.name == 'BBT'){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AssetsDetailBBTPage(data:item);
                          }));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AssetsDetailPage(data:item,);
                          }));
                        }}
                        );
                      },
                      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
                  ),
                )
            )
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: null,
        elevation: 0,
        centerTitle: false,
        title: Text('assets'.tr(),style: TextStyle(color: CommonUtil.getTitleColor(context)),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AssetsRecordPage(symbolList: list,);
              }));
            },
            child: Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
              child: Center(
                child: Text('财务记录',style: TextStyle(color: CommonUtil.getTitleColor(context))),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildAssetCard(),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: CommonUtil.isDark(context)?Colours.dark_bg_gray:Colours.bg_gray,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(ScreenUtil().setWidth(40)),topRight: Radius.circular(ScreenUtil().setWidth(40)))
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(120),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('assets_detail'.tr(),style: TextStyle(color: CommonUtil.getTitleColor(context),fontSize: ScreenUtil().setSp(32),fontWeight: FontWeight.w500)),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                setState(() {
                                  hideZeroAssets = !hideZeroAssets;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  !hideZeroAssets?Image.asset('res/ic_check_n.png',width: ScreenUtil().setWidth(24),):Image.asset('res/ic_check_p.png',width: ScreenUtil().setWidth(24),),
                                  Padding(
                                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                                      child:Text('asstes_hide'.tr(),style: TextStyle(color: CommonUtil.getTextGreyColor(context),fontSize: ScreenUtil().setSp(24),),)
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: ScreenUtil().setHeight(2),
                      ),
                    ],
                  )
              ),
              Container(
                color: CommonUtil.isDark(context)?Colours.dark_bg_gray:Colours.bg_gray,
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),bottom: ScreenUtil().setHeight(200),top: ScreenUtil().setHeight(40),),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: hideZeroAssets?listHave.length:list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: ScreenUtil().setHeight(40),
                        crossAxisSpacing: ScreenUtil().setWidth(23),
                        childAspectRatio: 1.3),
                    itemBuilder: (BuildContext context, int index) {
                      //Widget Function(BuildContext context, int index)
                      return _renderItem(index);
                    }),
              )
            ],
          ),
        ),
        onRefresh: () async {
          getData();
        },
      )
    );
  }
}
