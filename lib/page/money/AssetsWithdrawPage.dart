import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/page/contract/ScanPage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';

import 'AssetsSeachPage.dart';

class AssetsWithdrawPage extends StatefulWidget {
  final MoneyListDataData item;

  const AssetsWithdrawPage({Key key, this.item}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<AssetsWithdrawPage> with WidgetsBindingObserver  {
  String code = "";
  final TextEditingController _address = new TextEditingController();
  final TextEditingController _count = new TextEditingController();
  final TextEditingController _fee = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _code = new TextEditingController();

  bool showPwd = true;

  num sjdz = 0;

  MoneyListDataData data;
  String mentionMoneyHint = "";

  //定义变量
  Timer _timer;
  //倒计时数值
  var countdownTime = 0;

  StreamSubscription  _sub;


  @override
  void initState() {
    super.initState();
    _sub = eventBus.on<RefreshCode>().listen((event) {
      //FocusScope.of(context).requestFocus(FocusNode());
      if(!CommonUtil.isEmpty(event.address)){
        setState(() {
          _address.text = event.address;
        });
      }
    });
    WidgetsBinding.instance.addObserver(this);
    if(widget.item != null){
      setState(() {
        data = widget.item;
        code = widget.item.coin.name;
        mentionMoneyHint = CommonUtil.isEmpty(widget.item.coin.mentionMoneyHint)?'':widget.item.coin.mentionMoneyHint;
      });
    }
  }


  bool showBottom = true;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if(MediaQuery.of(context).viewInsets.bottom==0){
          setState(() {
            showBottom = true;
          });
        }else{
          setState(() {
            showBottom = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  void getCode(){
    _progressDialog.show();
    DioManager.getInstance().post(Url.WITHDARW_CODE, null, (data){
      _progressDialog.hide();
      startCountdown();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  String _renderUsable(){
    if(data == null){
      return '0';
    }
    return data.balance.toString();
  }

  String _renderFree(){
    if(data != null){
      return data.coin.maxTxFee.toString();
    }else{
      return '0';
    }
  }


  _clear(){
    setState(() {
      _address.text = '';
      _count.text = '';
    });
  }

  _scan() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses[Permission.camera] == PermissionStatus.granted) {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _address.text = barcode;
      });
     /* Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ScanPage();
      }))*//*.then((data){
        Future.delayed(Duration(seconds: 2),(){
          String abc = data;
          setState(() {
            _address.text = abc;
          });
        });
      })*/;
    }
  }

  _action(data){
    setState(() {
      _address.text = data;
    });
  }

  _submit(){
    _progressDialog.show();
    var params ={
      'jyPassword':CommonUtil.generateMd5(_password.text),
      'unit':code,
      'amount':_count.text,
      'fee':_renderFree(),
      'address':_address.text,
      'remark':'',
      'code':_code.text,
    };

    DioManager.getInstance().post(Url.WITHDRAW, params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      eventBus.fire(new RefreshAsstes());
      Navigator.pop(context);
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  TextStyle tvTitle = TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24));

  ProgressDialog _progressDialog;
  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
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
    return Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        centerTitle: false,
        leading: AppBarReturn(),
        title: Text('withdraw'.tr()),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(300)),
                child:_buildForm(),
              ),
              showBottom?
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(268),
                  decoration: BoxDecoration(
                    color: Color(0xff1b2438),
                    boxShadow: [BoxShadow(color: Color(0x630F0F10), offset: Offset(0.0, -4.0),blurRadius: 48.0, spreadRadius: 0.0), BoxShadow(color: Color(0xFF000000))],
                  ),
                  child:Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(42),bottom: ScreenUtil().setHeight(42)),
                    child:  Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('amount_sj'.tr(),style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24)),),
                            Text(sjdz.toString()+' '+code.toUpperCase(),style: TextStyle(color:Color(0xffE0E0E7),fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),)
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(42)),
                          width: double.infinity,
                          height: ScreenUtil().setHeight(88),
                          child: RaisedButton(
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                            color: Theme.of(context).accentColor,
                            child: Text("submit".tr()),
                            onPressed: () {
                              _submit();
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ),
              ):Container()
            ],
          ),
        )
      ),
    );
  }


  Widget _buildForm(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              color: Color(0xff161921),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(CommonUtil.isEmpty(code)?'deposit_select'.tr():code,style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                  Row(
                    children: <Widget>[
                      Text(CommonUtil.isEmpty(code)?'deposit_select'.tr():code,style: TextStyle(color: Color(0xff5B606E),fontSize: ScreenUtil().setSp(28)),),
                      Icon(Icons.keyboard_arrow_right,color: Color(0xff5B606E),)
                    ],
                  )
                ],
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AssetsSeachPage(type: 'deposit',);
              })).then((value) => setState((){
                MoneyListDataData item = value;
                if(item == null){
                  return;
                }
                setState(() {
                  code = item.coin.name;
                  data = item;
                  mentionMoneyHint = CommonUtil.isEmpty(item.coin.mentionMoneyHint)?'':item.coin.mentionMoneyHint;
                });
              }));
            },
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top:ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(0)),
                  child: Text(
                      'withdrawAddress'.tr(),
                      style:tvTitle
                  ),
                ),
                TextField(
                  controller: _address,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      fontFamily: 'Din'
                  ),
                  decoration:InputDecoration(
                      contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                      suffixIcon: GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: Image.asset('res/scan.png',width: ScreenUtil().setWidth(28),height: ScreenUtil().setHeight(20),)
                        ),
                        onTap: (){
                          _scan();
                        },
                      )
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            'withdraw_count'.tr(),
                            style:tvTitle
                        ),
                      ],
                    )
                ),
                TextField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp(r"[\d.]"))
                  ],
                  onChanged: (e){
                    if(e == ''){
                      setState(() {
                        sjdz = 0;
                      });
                      return;
                    }
                    num count = num.parse(e);
                    setState(() {
                      sjdz = count - data.coin.maxTxFee;
                    });
                  },
                  controller: _count,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      fontFamily: 'Din'
                  ),
                  decoration:InputDecoration(
                      contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                      suffixIcon: Container(
                        width: ScreenUtil().setWidth(200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(code.toUpperCase(),style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(32),color: Color(0xffe0e0e7)),),
                            GestureDetector(
                              child: Text('all'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(32),color: Theme.of(context).accentColor),),
                              onTap: (){
                                setState(() {
                                  _count.text = data.balance.toString();
                                });
                                num count = num.parse(data.balance.toString());
                                setState(() {
                                  sjdz = count - data.coin.maxTxFee;
                                });
                              },
                            )
                          ],
                        ),
                      )
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('keyongyue'.tr()+":"+_renderUsable()+' '+code.toUpperCase(),style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),)
                    ],
                  ),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                ),
                Container(
                  padding: EdgeInsets.only(top:ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(0)),
                  child: Text(
                      'freeAmount'.tr(),
                      style:tvTitle
                  ),
                ),
                TextField(
                  enabled:false,
                  controller: _fee,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      fontFamily: 'Din'
                  ),
                  decoration:InputDecoration(
                      hintText: _renderFree(),
                      contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                      suffixIcon: Container(
                        width: ScreenUtil().setWidth(200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(code.toUpperCase(),style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(32),color: Color(0xffe0e0e7)),),
                          ],
                        ),
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:ScreenUtil().setHeight(60),bottom: ScreenUtil().setHeight(0)),
                  child: Text(
                      'safe_zjmm'.tr(),
                      style:tvTitle
                  ),
                ),
                TextField(
                  controller: _password,
                  autofocus: false,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText:showPwd,
                  style: TextStyle(
                    color:Colors.white,
                    fontSize: ScreenUtil().setSp(32),
                  ),
                  decoration:InputDecoration(
                      contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                      suffixIcon: GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(14),
                            child: Image.asset(showPwd?'res/eye_open.png':'res/eye_close.png',width: ScreenUtil().setWidth(28),height: ScreenUtil().setHeight(20),)
                        ),
                        onTap: (){
                          setState(() {
                            showPwd = !showPwd;
                          });
                        },
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:ScreenUtil().setHeight(60),bottom: ScreenUtil().setHeight(0)),
                  child: Text(
                      'verify_mobile'.tr(),
                      style:tvTitle
                  ),
                ),
                Container(
                    child: Stack(
                      children: <Widget>[
                        TextField(
                          controller: _code,
                          autofocus: false,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                          ),
                          decoration:InputDecoration(
                            contentPadding:EdgeInsets.only(right: ScreenUtil().setWidth(150)),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: (){
                                getCode();
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(180),
                                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15),),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      width: ScreenUtil().setWidth(2),
                                      height: ScreenUtil().setHeight(50),
                                      color: CommonUtil.isDark(context) ? Colours.dark_line : Colours.line,
                                    ),
                                    Text(countdownTime>0?"${countdownTime}s":'register_hq_yzm'.tr(),style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      color: Theme.of(context).accentColor
                                    ),)
                                  ],
                                ),
                              ),
                            )
                        )
                      ],
                    )
                ),
                Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(40)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(mentionMoneyHint,style: TextStyle(
                            color: Color(0xFF9496A2),fontSize: ScreenUtil().setSp(24)
                        ),),
                      ],
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}


class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets/2,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}