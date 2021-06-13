import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/SocketManage.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/common/mqtt.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/MarketItem.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/model/TransObject.dart';
import 'package:hibi/model/TransObjectList.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/model/socket_info_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/model/treaty_list_entity.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/model/version_entity.dart';
import 'package:hibi/page/treaty/TradingTreatyPage.dart';
import 'package:hibi/page/user/LoginPage.dart';
import 'package:hibi/page/user/RegisterPage.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/state/TreatyState.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:web_socket_channel/io.dart';

import 'home/HomePage.dart';
import 'kline/chart/chart_model.dart';
import 'market/MarketPage.dart';
import 'money/MoneyPage.dart';
import 'trading/TradingPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MainPage> with WidgetsBindingObserver{
  int lastTime = 0;

  List<Widget> pageList = <Widget>[HomePage(), MarketPage(), TradingPage(), MoneyPage(),TradingTreatyPage()];
  int _selectedIndex = 0;
  PageController _pageController;

  String  lastSubName = 'bvnt_usdt';
  StreamSubscription  _sub;

  StreamSubscription  _sub2;


  @override
  void initState() {
    super.initState();
    this._pageController =PageController(initialPage: this._selectedIndex, keepPage: true);
    _sub = eventBus.on<SocketTradeSummary>().listen((event) {
      Provider.of<SymbolState>(context, listen: false).updateSymbol(event.data);
    });
    _sub2 = eventBus.on<GotoTrade>().listen((event) {
      this._pageController.jumpToPage(2);
      setState(() {
        _selectedIndex = 2;
      });
    });
    getThumbData();
    getConfig();
    //initUser();
    getAssests();
    getFlowType();
    WidgetsBinding.instance.addObserver(this);
    getTreatyThumb();
  }

  void getTreatyThumb(){
    DioManager.getInstance().post(Url.TREATY_THUMB, null, (data){
      TreatyListEntity symbolListEntity = JsonConvert.fromJsonAsT(data);
      Provider.of<TreatyState>(context, listen: false).updateSymbolList(symbolListEntity.data);
      //initSocket();
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed:// 应用程序可见，前台
        print('resumed');
        //MqttUtils.getInstance().dreConnect();
        if(Platform.isIOS){
          initSocket();
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        print('paused');
        if(Platform.isIOS){
          MqttUtils.getInstance().disConnect();
        }
        break;
    }
  }

  void getFlowType(){
    DioManager.getInstance().post(Url.FLOW_TYPE, null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      Global.flowtypes = dataMap['data'];
    }, (error){
      print("flowtype:error"+error);
    });
  }

  Future<void> initUser() async {
    DioManager.getInstance().post(Url.USER_INFO, null, (data2){
      UserEntity userEntity = JsonConvert.fromJsonAsT(data2);
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(userEntity.data);
    }, (error){
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(null);
    });
  }

  void getConfig(){
    String url = '';
    if(Platform.isAndroid){
      url = "/uc/app/info/android/version";
    }else{
      url = "/uc/app/info/iPhone/version";
    }
    DioManager.getInstance().post(url, null, (data){
      VersionEntity versionEntity = JsonConvert.fromJsonAsT(data);
      int code = int.tryParse(versionEntity.data.versionCode);
      if(code > Config.VERSION_CODE){
        showUpdateDialog(versionEntity.data.isUpdate == 1 ?true:false, versionEntity.data.description,versionEntity.data.url);
      }
    }, (error){

    });
  }

  void getAssests(){
    if(Provider.of<UserInfoState>(context, listen: false).isLogin){
      String type = "BIBI";
      var param = {'walletType':type};
      DioManager.getInstance().post(Url.PROPERTY, param, (data){
        MoneyListEntity moneyListEntity = JsonConvert.fromJsonAsT(data);
        setState(() {
          Global.assetsList = moneyListEntity.data.data;
        });
      }, (error){
      });
    }
  }

  void showUpdateDialog(bool isUpdate,String content,String url){
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B2438),
          title: Text('update'.tr()),
          content:Text(content),
          actions: <Widget>[
            isUpdate?
            Container():
            FlatButton(
              child: Text('cancel'.tr(),style: TextStyle(
                  color: Config.greyColor
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('ok'.tr(),style: TextStyle(
                  color: Colours.dark_accent_color
              ),),
              onPressed: () async {
                await launch(url);
              },
            )
          ],
        );
      },
    );
  }

  void getThumbData() {
    DioManager.getInstance().post(Url.THUMB, null, (data){
      SymbolListEntity symbolListEntity = JsonConvert.fromJsonAsT(data);
      List<String> collects = SpUtil.getStringList("collect",defValue: []);
      for(SymbolListData item in symbolListEntity.data){
        for(String str in collects){
          if(item.symbol == str){
            item.isCollect = true;
          }
        }
      }
      Provider.of<SymbolState>(context, listen: false).updateSymbolList(symbolListEntity.data);
      initSocket();
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _sub2.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  initSocket() async{
    DioManager.getInstance().post(Url.SOCKET_INFO, null, (data2){
      SocketInfoEntity socketInfoEntity = JsonConvert.fromJsonAsT(data2);
      MqttUtils.getInstance().init(host: socketInfoEntity.data.host,port: socketInfoEntity.data.wsPort,user: socketInfoEntity.data.username,password: socketInfoEntity.data.password);
      MqttUtils.getInstance().connect().then((value) => {
        if(value == 0){
          MqttUtils.getInstance().subscribe("/topic/market/trade_summary")
        }
      });
    }, (error2){
      CommonUtil.showToast(error2);
    });
  }

  Future<void> _onItemTapped(int index) async {
    if (await Vibration.hasCustomVibrationsSupport() && Platform.isAndroid) {
      Vibration.vibrate(duration: Config.vibrateTime, amplitude: Config.vibrateAmp);
    }
    if(index ==3 && !Provider.of<UserInfoState>(context, listen: false).isLogin){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
      return;
    }

    this._pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  Color getColor(int value) {
    return this._selectedIndex == value
        ? Theme.of(context).accentColor
        : Color(0xFF414C68);
  }


  Widget getImageIcon(int value){
    Color selectedColor = Theme.of(context).accentColor;
    Color unselectedColor =  Color(0xFF414C68);
    switch(value){
      case 0:
        if(_selectedIndex == value){
          return(Image.asset("res/ic_home.png",width: ScreenUtil().setWidth(44),height: ScreenUtil().setWidth(40),color: selectedColor,));
        }else{
          return(Image.asset("res/ic_home.png",width: ScreenUtil().setWidth(44),height: ScreenUtil().setWidth(40),color: unselectedColor,));
        }
        break;
      case 1:
        if(_selectedIndex == value){
          return(Image.asset("res/ic_market.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: selectedColor));
        }else{
          return(Image.asset("res/ic_market.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: unselectedColor));
        }
        break;
      case 2:
        if(_selectedIndex == value){
          return(Image.asset("res/ic_trading.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: selectedColor));
        }else{
          return(Image.asset("res/ic_trading.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: unselectedColor));
        }
        break;
      case 3:
        if(_selectedIndex == value){
          return(Image.asset("res/ic_money.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: selectedColor));
        }else{
          return(Image.asset("res/ic_money.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: unselectedColor));
        }
        break;
      case 4:
        if(_selectedIndex == value){
          return(Image.asset("res/ic_money.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: selectedColor));
        }else{
          return(Image.asset("res/ic_money.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),color: unselectedColor));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1624);
    return  WillPopScope(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: this.pageList,
          controller: _pageController,
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 6.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x8C0F0F10), offset: Offset(0.0, -4.0),blurRadius: 48.0, spreadRadius: 0.0),BoxShadow(color: Colours.dark_bg_gray)],
            ),
            child: Material(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child:  InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          _onItemTapped(0);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              getImageIcon(0),
                              Padding(
                                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                                  child:Text("home".tr(), style: TextStyle(color: getColor(0),fontSize: ScreenUtil().setSp(24)))
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child:  InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          _onItemTapped(1);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              getImageIcon(1),
                              Padding(
                                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                                  child:Text("quotation".tr(), style: TextStyle(color: getColor(1),fontSize: ScreenUtil().setSp(24)))
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child:  InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          _onItemTapped(2);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              getImageIcon(2),
                              Padding(
                                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                                  child:Text("transaction".tr(), style: TextStyle(color: getColor(2),fontSize: ScreenUtil().setSp(24)))
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child:  InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          _onItemTapped(4);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              getImageIcon(4),
                              Padding(
                                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                                  child:Text("tab_hy".tr(), style: TextStyle(color: getColor(4),fontSize: ScreenUtil().setSp(24)))
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  Expanded(
                    child:  InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          _onItemTapped(3);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              getImageIcon(3),
                              Padding(
                                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                                  child:Text("assets".tr(), style: TextStyle(color: getColor(3),fontSize: ScreenUtil().setSp(24)))
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
        onWillPop: () {
          int newTime = DateTime.now().millisecondsSinceEpoch;
          int result = newTime - lastTime;
          lastTime = newTime;
          if (result > 2000) {
            //Toast.show(context, '再按一次退出');
          } else {
            SystemNavigator.pop();
          }
          return null;
        });
  }

}
