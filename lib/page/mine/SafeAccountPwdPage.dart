import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SafeAccountPwdPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<SafeAccountPwdPage> {

  //定义变量
  Timer _timer;
  //倒计时数值
  var countdownTime = 0;
  final TextEditingController _pwd = new TextEditingController();
  final TextEditingController _pwd2 = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  bool showPwd2 = true;
  bool showPwd3 = true;

  UserData user = new UserData();

  @override
  void initState() {
    super.initState();
    UserData data = Provider.of<UserInfoState>(context, listen: false).userInfoModel;
    setState(() {
      user = data;
    });
  }


  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
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

  void _submit(){

    if(CommonUtil.isEmpty(_pwd.text)){
      CommonUtil.showToast('pwd_label2'.tr());
      return;
    }

    if(_pwd.text != _pwd2.text){
      CommonUtil.showToast('pwd_label4'.tr());
      return;
    }


    _progressDialog.show();
    var params = {
      'jyPassword':CommonUtil.generateMd5(_pwd.text),
    };
    DioManager.getInstance().post(Url.USER_ACCOUNT_PWD, params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      UserData userData = Provider.of<UserInfoState>(context, listen: false).userInfoModel;
      userData.fundsVerified = 1;
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(userData);
      eventBus.fire(new RefreshUserInfo());
      Navigator.of(context).pop();
    }, (error){
      CommonUtil.showToast(error);
      _progressDialog.hide();
    });
  }

  void getCode(){
    if(countdownTime != 0){
      return;
    }

    _progressDialog.show();
    DioManager.getInstance().post(Url.USER_UPDATE_PWD_CODE, null, (data){
      _progressDialog.hide();
      startCountdown();
      final snackBar = SnackBar(
        content: Text('register_send_success'.tr()+':'+user.mobilePhone),
        action: SnackBarAction(
          label: 'label_undo'.tr(),
          onPressed: () {
          },
        ),);
      Scaffold.of(context).showSnackBar(snackBar);
    }, (error){
      CommonUtil.showToast(error);
      _progressDialog.hide();
    });
  }


  ProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    _progressDialog.style(
      message: 'loading'.tr(),
      backgroundColor: Colours.dark_bg_gray,
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
          leading: AppBarReturn(),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                    child: Text('safe_zjmm'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(38)),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                    child: Text('password_new'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(24)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                    child: TextFormField(
                      controller: _pwd,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText:showPwd2,
                      autofocus: false,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                      ),
                      validator: (value) {
                        Pattern pattern =
                            r'^\d{6,20}$';
                        RegExp reg = new RegExp(pattern);
                        if (!reg.hasMatch(value)) {
                          return 'register_pwd_account_mathc'.tr();
                        }
                        return null;
                      },
                      decoration:InputDecoration(
                          hintText:"password_new".tr(),
                          suffixIcon: IconButton(
                            color: Colors.white,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: ImageIcon(AssetImage(showPwd2?'res/eye_close.png':'res/eye_open.png')),
                            onPressed: (){
                              setState(() {
                                showPwd2 = !showPwd2;
                              });
                            },
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                    child: Text('passwrord_aiagin'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(24)),),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                    child: TextFormField(
                      controller: _pwd2,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText:showPwd3,
                      autofocus: false,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                      ),
                      validator: (value) {
                        Pattern pattern =
                            r'^\d{6,20}$';
                        RegExp reg = new RegExp(pattern);
                        if (!reg.hasMatch(value)) {
                          return 'register_pwd_account_mathc'.tr();
                        }
                        return null;
                      },
                      decoration:InputDecoration(
                          hintText:"passwrord_aiagin".tr(),
                          suffixIcon: IconButton(
                            color: Colors.white,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: ImageIcon(AssetImage(showPwd3?'res/eye_close.png':'res/eye_open.png')),
                            onPressed: (){
                              setState(() {
                                showPwd3 = !showPwd3;
                              });
                            },
                          )
                      ),
                    ),
                  ),
                  Padding(
                    child: SizedBox(
                      width: ScreenUtil().setWidth(686),
                      height: ScreenUtil().setHeight(80),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.all(0.0),
                        child: Text('submit'.tr(),style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Future.delayed(Duration(milliseconds: Config.delayedTime), (){
                              _submit();
                            });
                          }
                        },
                        elevation: 4.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(80),bottom: ScreenUtil().setHeight(60)),
                  )
                ],
              ),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
            ),
          ),
        )
    );
  }
}
