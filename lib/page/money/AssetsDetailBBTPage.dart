import 'dart:convert';
import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_detail_entity.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/page/money/ActivityHistoryPage.dart';
import 'package:hibi/page/money/AssetsDepositPage.dart';
import 'package:hibi/page/money/AssetsDetailPage.dart';
import 'package:hibi/page/money/AssetsWithdrawPage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AssetsDetailBBTPage extends StatefulWidget {
  final MoneyListDataData data;

  const AssetsDetailBBTPage({Key key, this.data}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<AssetsDetailBBTPage>  with SingleTickerProviderStateMixin {

  bool canDraw = false;
  bool canDeposit = false;

  AssetsDetailData data ;
  
  num pointCount = 8;
  StreamSubscription  _sub;
  StreamSubscription  _sub2;


  @override
  void initState() {
    super.initState();
    _sub = eventBus.on<RefreshAsstes>().listen((event) {
      _initAssets();
    });
    _sub2 = eventBus.on<GotoTrade>().listen((event) {
      Navigator.pop(context);
    });
    _initAssets();
  }

  @override
  void dispose() {
    _sub.cancel();
    _sub2.cancel();
    super.dispose();
  }

  void _initAssets(){
    if(widget.data.coin.canRecharge == 1){
      canDeposit = true;
    }
    if(widget.data.coin.canWithdraw == 1){
      canDraw = true;
    }
    _getAssetsDetail();
  }

  Future _getAssetsDetail() async{
    var params = {'symbol':widget.data.coin.name};
    DioManager.getInstance().post(Url.ASSETS_DETAIL, params, (data2){
      AssetsDetailEntity assetsDetailEntity = JsonConvert.fromJsonAsT(data2);
      setState(() {
        data = assetsDetailEntity.data;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  TextStyle tvTitlesub = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvNumber = TextStyle(color: Colours.dark_textTitle,fontFamily:'Din',fontSize: ScreenUtil().setSp(28));

  Widget _buildTop(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('assets_all'.tr(),style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child:Text(data.totalAssets.toString(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: ScreenUtil().setSp(48),fontFamily: 'Din'),),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('keyongyue'.tr(),style: tvTitlesub,),
                      Padding(
                        child: Text(data.availableBalance.toString(),style: tvNumber,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('zhehe'.tr()+"(CNY)",style: tvTitlesub,),
                      Padding(
                        child: Text(data.convertIntoCNY.toString(),style: tvNumber,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                )
              ],
            ),
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
          )
        ],
      ),
    );
  }

  Widget _buildBB(AssetsDetailDataCoinParticularsList item){
    String title = '';
    String resIcon = '';
    bool showHistory = true;
    switch(item.accountTypeEnum){
      case "BIBI":
        title = 'assets_bbzh'.tr();
        resIcon = 'res/assets_bb.png';
        break;
      case "PURCHASE":
        title = 'assets_sgzh'.tr();
        resIcon = 'res/assets_sg.png';
        showHistory = false;
        break;
      case "CALCULA":
        title = 'assets_slzh'.tr();
        resIcon = 'res/assets_sl.png';
        showHistory = false;
        break;
      case "ACTIVITY":
        title = 'assets_xdzh'.tr();
        resIcon = 'res/assets_xd.png';
        break;
      case "FINANCE":
        title = 'assets_lczh'.tr();
        resIcon = 'res/assets_lc.png';
        break;
    }
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
        ),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.only(left:ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
          decoration: BoxDecoration(
              color: Colours.dark_bg_gray_,
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
          ),
          width: double.infinity,
          height: ScreenUtil().setHeight(270),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(resIcon,width: ScreenUtil().setWidth(76),height: ScreenUtil().setWidth(76),),
                            Padding(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(title,style: TextStyle(color: Colours.dark_text_grey2,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600),),
                                  Text(item.totalAssets.toString(),style: TextStyle(color: Colours.dark_text_gray,fontFamily:'Din',fontSize: ScreenUtil().setSp(36)),)
                                ],
                              ),
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
                          child: Image.asset('res/arrow_down.png',width: ScreenUtil().setWidth(20),height: ScreenUtil().setWidth(10),),
                        )
                      ],
                    ),
                  )
              ),
              Divider(),
              _renderBBt(item.accountTypeEnum,item)
            ],
          ),
        ),
      ),
      onTap: (){
        if(item.accountTypeEnum == 'ACTIVITY'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ActivityHistoryPage();
          }));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AssetsDetailPage(data:widget.data,type: item.accountTypeEnum,isBBT:true,availableBalance:item.availableBalance,blockedBalance:item.blockedBalance,convertIntoCNY:item.convertIntoCNY,totalAssets:item.totalAssets,showHistory: showHistory,);
          }));
        }
      },
      behavior: HitTestBehavior.opaque,
    );
  }


  Widget _renderBBt(String type,AssetsDetailDataCoinParticularsList item){
    switch(type){
      case "BIBI":
        return Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('keyongyue'.tr(),style: tvTitlesub,),
                    Padding(
                      child: Text(item.availableBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('dongjie'.tr(),style: tvTitlesub,),
                    Padding(
                      child: Text(item.blockedBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex:4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('zhehe'.tr()+"(CNY)",style: tvTitlesub,),
                    Padding(
                      child: Text(item.convertIntoCNY.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case "PURCHASE":
        return Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('keyongyue'.tr(),style: tvTitlesub,),
                    Padding(
                      child: Text(item.availableBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("",style: tvTitlesub,),
                    /*Padding(
                      child: Text(convertIntoCNY,style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )*/
                  ],
                ),
              ),
              Expanded(
                flex:4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('交易金(USDT)',style: tvTitlesub,),
                    Padding(
                      child: Text(data.leverDealGold.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case "CALCULA":
        return Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('keyongyue'.tr(),style: tvTitlesub,),
                    Padding(
                      child: Text(item.availableBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('',style: tvTitlesub,),
                  ],
                ),
              ),
              Expanded(
                flex:4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('zhehe'.tr()+"(CNY)",style: tvTitlesub,),
                    Padding(
                      child: Text(item.convertIntoCNY.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case "ACTIVITY":
        return Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('锁定额度',style: tvTitlesub,),
                    Padding(
                      child: Text(item.blockedBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),

              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('',style: tvTitlesub,),
                  ],
                ),
              ),
              Expanded(
                flex:4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('镜像算力额度',style: tvTitlesub,),
                    Padding(
                      child: Text(item.systemLockBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      default:
        return Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('keyongyue'.tr(),style: tvTitlesub,),
                    Padding(
                      child: Text(item.availableBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('dongjie'.tr(),style: tvTitlesub,),
                    Padding(
                      child: Text(item.blockedBalance.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex:4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('zhehe'.tr()+"(CNY)",style: tvTitlesub,),
                    Padding(
                      child: Text(item.convertIntoCNY.toString(),style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
    }
  }

  List<Widget> _buildAssets(){
    List<Widget> list = [];
    if(data != null){
      for(int i=0;i<data.coinParticularsList.length;i++){
        list.add(_buildBB(data.coinParticularsList[i]));
      }
    }
    return list;
  }


  ProgressDialog _progressDialog;
  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    _progressDialog.style(
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
        fontSize: 13.0,
      ),
      messageTextStyle: TextStyle(
        fontSize: 19.0,
      ),
    );
    return new Material(
        child: Scaffold(
          backgroundColor: Colours.dark_bg_gray,
          appBar: AppBar(
            leading: AppBarReturn(),
            centerTitle: false,
            title: Text(widget.data.coin.name+'assets'.tr()),
          ),
          body: data == null?Container():SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setHeight(32),bottom: ScreenUtil().setHeight(50)),
              child: Column(
                children: <Widget>[
                  _buildTop(),
                  Column(
                    children: _buildAssets(),
                  )
                ],
              ),
            )
          )
        )
    );
  }
}
