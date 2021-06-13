import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_detail_entity.dart';
import 'package:hibi/model/assets_record_list_entity.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/SmallFlatButton.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AssetsDepositPage.dart';
import 'AssetsWithdrawPage.dart';
import 'ChangePage.dart';


class AssetsDetailPage extends StatefulWidget {
  final MoneyListDataData data;
  final String type;
  final bool isBBT;
  final double availableBalance;
  final double blockedBalance;
  final double convertIntoCNY;
  final double totalAssets;
  final bool showHistory;

  const AssetsDetailPage({Key key, this.data, this.type, this.isBBT = false, this.availableBalance, this.blockedBalance, this.convertIntoCNY, this.totalAssets, this.showHistory=true}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<AssetsDetailPage>  with SingleTickerProviderStateMixin {
  bool canDraw = false;
  bool canDeposit = false;
  bool canTrans = false;
  AssetsDetailData data;
  List<AssetsRecordListDataData> list = [];
  int _page = 1;
  bool hasMore = true;
  bool isLoad = false;

  ScrollController _controller = new ScrollController();

  StreamSubscription  _sub;
  String type = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && hasMore) {
        _onLoading();
      }
    });
    _sub = eventBus.on<RefreshAsstes>().listen((event) {
      _initAssets();
      _getHistory();
    });
    _initAssets();
    _getHistory();
  }

  void _getHistory(){
    _onRefresh();
  }

  Future _onRefresh() async  {
    setState(() {
      _page = 1;
    });
    var params ={'pageNo':1,'pageSize':20,'symbol':widget.data.coin.name,'type':type,'accountType':accountType()};
    DioManager.getInstance().post(Url.MONEY_DEPOSIT, params, (data) async {
      AssetsRecordListEntity assetsRecordListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        list =  assetsRecordListEntity.data.data;
        if(assetsRecordListEntity.data.total <= 1 * 20){
          setState(() {
            hasMore = false;
          });
        }else{
          _page = 2;
        }
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  Future _onLoading() async {
    if(isLoad){
      return;
    }
    setState(() {
      isLoad = true;
    });
    var params ={'pageNo':_page,'pageSize':20,'symbol':widget.data.coin.name,'type':type,'accountType':accountType()};
    DioManager.getInstance().get(Url.MONEY_DEPOSIT, params, (data) async {
      AssetsRecordListEntity assetsRecordListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        list.addAll(assetsRecordListEntity.data.data);
        if(assetsRecordListEntity.data.total <= _page * 20){
          setState(() {
            hasMore = false;
          });
        }else{
          _page = _page+1;
        }
        setState(() {
          isLoad = false;
        });
      });
    }, (error){
      CommonUtil.showToast(error);
      setState(() {
        isLoad = false;
      });
    });
  }

  Widget getItem(int index){
    AssetsRecordListDataData item = list[index];
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(210),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(Global.flowtypes[item.type.toString()],style: tvTitle,)
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('count'.tr(),style: tvValue,),
                      Padding(
                        child: Text(item.amount.toString(),style: tvTitle,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex:2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('status'.tr(),style: tvValue,),
                      Padding(
                        child: Text('success'.tr(),style: tvTitle,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex:3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('time'.tr(),style: tvValue,),
                      Padding(
                        child: Text(item.createTime == null?'':item.createTime.toString(),style: tvTitle,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Color(0xff1B1F2C),
            height: ScreenUtil().setHeight(2),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _initAssets(){
    if(widget.data.coin.canRecharge == 1){
      canDeposit = true;
    }
    if(widget.data.coin.canWithdraw == 1){
      canDraw = true;
    }
    if(widget.data.coin.canTransfer == 1){
      canTrans = true;
    }
    _getAssetsDetail();
  }
  
  String getType(int typeNum){
    String type = "";
    switch(typeNum){
      case 0:
        type = 'type_0'.tr();
        break;
      case 1:
        type = 'type_1'.tr();
        break;
      case 2:
        type = 'type_2'.tr();
        break;
      case 3:
        type = 'type_3'.tr();
        break;
      case 4:
        type = 'type_4'.tr();
        break;
      case 5:
        type = 'type_5'.tr();
        break;
      case 6:
        type = 'type_6'.tr();
        break;
      case 7:
        type = 'type_7'.tr();
        break;
      case 8:
        type = 'type_8'.tr();
        break;
      case 9:
        type = 'type_9'.tr();
        break;
      case 10:
        type = 'type_10'.tr();
        break;
      case 11:
        type = 'type_11'.tr();
        break;
      case 12:
        type = 'type_12'.tr();
        break;
      case 13:
        type = 'type_13'.tr();
        break;
      case 14:
        type = 'type_14'.tr();
        break;
    }
    return type;
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

  AssetsDetailDataCoinParticularsList getCurret(String type){
    for(AssetsDetailDataCoinParticularsList item in data.coinParticularsList){
      if(item.accountTypeEnum == type){
        return item;
      }
    }
  }

  int accountType(){
    switch(widget.type){
      case "BIBI":
        return 0;
        break;
      case "PURCHASE":
        return 2;
        break;
      case "CALCULA":
        return 1;
        break;
      case "FINANCE":
        return 6;
        break;
    }
    return 0;
  }

  TextStyle tvTitlesub = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvNumber = TextStyle(color: Colours.dark_textTitle,fontFamily:'Din',fontSize: ScreenUtil().setSp(28));

  Widget _buildBBT(){
    if(data == null){
      return Container();
    }

    String title = '';
    String resIcon = '';
    String total = '';
    String availableBalance = '';
    String blockedBalance = '';
    String convertIntoCNY = '';
    switch(widget.type){
      case "BIBI":
        title = 'assets_bbzh'.tr();
        resIcon = 'res/assets_bb.png';
        total = getCurret('BIBI').totalAssets.toString();
        availableBalance = getCurret('BIBI').availableBalance.toString();
        blockedBalance = getCurret('BIBI').blockedBalance.toString();
        convertIntoCNY = getCurret('BIBI').convertIntoCNY.toString();
        break;
      case "PURCHASE":
        title = 'assets_sgzh'.tr();
        resIcon = 'res/assets_sg.png';
        total = getCurret('PURCHASE').totalAssets.toString();
        availableBalance = getCurret('PURCHASE').availableBalance.toString();
        blockedBalance = data.leverDealGold.toString();
        convertIntoCNY = getCurret('PURCHASE').convertIntoCNY.toString();
        break;
      case "CALCULA":
        title = 'assets_slzh'.tr();
        resIcon = 'res/assets_sl.png';
        total = getCurret('CALCULA').totalAssets.toString();
        availableBalance = getCurret('CALCULA').availableBalance.toString();
        blockedBalance = getCurret('CALCULA').blockedBalance.toString();
        convertIntoCNY = getCurret('CALCULA').convertIntoCNY.toString();
        break;
      case "ACTIVITY":
        title = 'assets_xdzh'.tr();
        resIcon = 'res/assets_xd.png';
        total = getCurret('ACTIVITY').totalAssets.toString();
        availableBalance = getCurret('ACTIVITY').blockedBalance.toString();
        blockedBalance = getCurret('ACTIVITY').systemLockBalance.toString();
        convertIntoCNY = getCurret('ACTIVITY').convertIntoCNY.toString();
        break;
      case "FINANCE":
        title = 'assets_lczh'.tr();
        resIcon = 'res/assets_lc.png';
        total = getCurret('FINANCE').totalAssets.toString();
        availableBalance = getCurret('FINANCE').availableBalance.toString();
        blockedBalance = getCurret('FINANCE').blockedBalance.toString();
        convertIntoCNY = getCurret('FINANCE').convertIntoCNY.toString();
        break;
    }
    if(!widget.isBBT){
      title = 'assets_bbzh'.tr();
      resIcon = 'res/assets_bb.png';
    }
    return Card(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
      ),
      elevation: 4.0,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(resIcon,width: ScreenUtil().setWidth(76),height: ScreenUtil().setWidth(76),),
                    Padding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(title,style: TextStyle(color: Colours.dark_text_grey2,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600),),
                          Text(widget.isBBT?total:data.totalAssets.toString(),style: TextStyle(color: Colours.dark_text_gray,fontFamily:'Din',fontSize: ScreenUtil().setSp(36)),)
                        ],
                      ),
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                    )
                  ],
                ),
              )
            ),
            Divider(),
            widget.isBBT?_renderBBt(widget.type,availableBalance,blockedBalance,convertIntoCNY):_renderElse()
          ],
        ),
      ),
    );
  }

  Widget _renderBBt(String type,String availableBalance,String blockedBalance,String convertIntoCNY){
    switch(widget.type){
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
                      child: Text(availableBalance,style: tvNumber,),
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
                      child: Text(blockedBalance,style: tvNumber,),
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
                      child: Text(convertIntoCNY,style: tvNumber,),
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
                      child: Text(availableBalance,style: tvNumber,),
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
                      child: Text(blockedBalance,style: tvNumber,),
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
                      child: Text(availableBalance,style: tvNumber,),
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
                      child: Text(convertIntoCNY,style: tvNumber,),
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
                      child: Text(availableBalance,style: tvNumber,),
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
                    Padding(
                      child: Text(convertIntoCNY,style: tvNumber,),
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
                    Text('镜像算力额度',style: tvTitlesub,),
                    Padding(
                      child: Text(blockedBalance,style: tvNumber,),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case "FINANCE":
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
                      child: Text(availableBalance,style: tvNumber,),
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
                      child: Text(blockedBalance,style: tvNumber,),
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
                      child: Text(convertIntoCNY,style: tvNumber,),
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


  Widget _renderElse(){
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
                    child: Text(data.availableBalance.toString(),style: tvNumber,),
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
                    child: Text(data.blockedBalance.toString(),style: tvNumber,),
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
                    child: Text(data.convertIntoCNY.toString(),style: tvNumber,),
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }


  String getTypeFromString(int index){
    switch(index){
      case 0:
        return "";
        break;
      case 1:
        return "0";
        break;
      case 2:
        return "1";
        break;
      case 3:
        return "2";
        break;
      case 4:
        return "3";
        break;
    }
  }

  void sortHistory(){
    List<Widget> list = [];

    Global.flowtypes.forEach((key, value) {
      list.add(SimpleDialogOption(
        child: new Text(value),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            type = key;
            _onRefresh();
          });
        },
      ));
    });
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor: Colours.dark_bg_gray,
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }

  TextStyle tvValue = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvTitle = TextStyle(color: Colours.dark_textTitle,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din',fontWeight: FontWeight.w500);

  Widget _buildHistory(){
    return Card(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
      ),
      elevation: 4.0,
      child: Container(
        decoration: BoxDecoration(
            color: Colours.dark_bg_gray_,
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
        ),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left:ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
              height: ScreenUtil().setHeight(100),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('assets_cwxq'.tr(),style: TextStyle(color: CommonUtil.getTitleColor(context),fontSize: ScreenUtil().setSp(32),fontWeight: FontWeight.w500)),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child:Image.asset('res/icon_sort.png',width: ScreenUtil().setWidth(36),height: ScreenUtil().setHeight(32),),
                    onTap: (){
                      sortHistory();
                    },
                  )
                ],
              ),
            ),
            Divider(
              height: ScreenUtil().setHeight(2),
              color: Color(0xff1B1F2C),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return getItem(index);
              },
            ),
            isLoad?Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(190),
                padding: EdgeInsets.all(8.0),
                child: Center(
                    child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator())
                )
            ):Container()
          ],
        ),
      ),
    );
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
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                      controller: _controller,
                      child: Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setHeight(32),bottom: ScreenUtil().setHeight(300)),
                        child: Column(
                          children: <Widget>[
                            _buildBBT(),
                            _buildHistory()
                          ],
                        ),
                      )
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colours.dark_bg_gray,
                        boxShadow: [BoxShadow(color: Color(0x630F0F10), offset: Offset(0.0, -4.0),    blurRadius: 24.0, spreadRadius: 0.0)],
                      ),
                      width: double.infinity,
                      height: ScreenUtil().setHeight(100),
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SmallFlatButton(text: 'assets_cb'.tr(),canClick:canDeposit,onClick: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return AssetsDepositPage(item: widget.data,);
                            }));
                          },),
                          SmallFlatButton(text: 'assets_tb'.tr(),canClick:canDraw,onClick: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return AssetsWithdrawPage(item: widget.data,);
                            }));
                          },),
                          SmallFlatButton(text: 'transaction'.tr(),onClick: (){
                            List<SymbolListData> _datas = Provider.of<SymbolState>(context, listen: false).symbol;
                            if(widget.data.coin.name != 'USDT'){
                              for(SymbolListData item in _datas){
                                if(item.coinSymbol == widget.data.coin.name){
                                  Global.curretSymbol = item.symbol;
                                  eventBus.fire(new GotoTrade());
                                  Navigator.pop(context);
                                  return;
                                }
                              }
                            }else{
                              eventBus.fire(new GotoTrade());
                              Navigator.pop(context);
                            }
                          },),
                          SmallFlatButton(text: 'assets_hz'.tr(),canClick:widget.isBBT,onClick: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ChangePage();
                            }));
                          },),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          )
        )
    );
  }
}
