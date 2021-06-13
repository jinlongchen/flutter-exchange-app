import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
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

class SafeEmailPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<SafeEmailPage> {

  //定义变量
  Timer _timer;
  //倒计时数值
  var countdownTime = 0;
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _code = new TextEditingController();
  final TextEditingController _pwd = new TextEditingController();


  bool canUnBind = false;
  bool showPwd = true;
  bool isSendCode = false;

  @override
  void initState() {
    super.initState();
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
    _progressDialog.show();
    var params = {
      'email':_username.text,
      'code':_code.text,
      'password':CommonUtil.generateMd5(_pwd.text)
    };

    DioManager.getInstance().post(Url.USER_BIND_EMAIL, params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      UserData userData = Provider.of<UserInfoState>(context, listen: false).userInfoModel;
      userData.email = _username.text;
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

    if(CommonUtil.isEmpty(_username.text)){
      CommonUtil.showToast("label_qsryx".tr());
      return;
    }
    _progressDialog.show();
    var params = {"email":_username.text};
    DioManager.getInstance().post(Url.USER_BIND_EMAIL_CODE, params, (data){
      _progressDialog.hide();
      startCountdown();
      if(!CommonUtil.isEmpty(_pwd.text)){
        setState(() {
          canUnBind = true;
        });
      }
      setState(() {
        isSendCode = true;
      });
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
    return new Material(
        child: Scaffold(
            backgroundColor: Colours.dark_bg_gray,
            appBar: AppBar(
              leading: AppBarReturn(),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                      child: Text('safe_yxbd'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(38)),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                      child: Text('regitser_mail'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(24)),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                      child: TextField(
                        controller: _username,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                        ),
                        decoration:InputDecoration(
                          hintText:"regitser_mail".tr(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                      child: Text('verify_email'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(24)),),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                        child: Stack(
                          children: <Widget>[
                            TextField(
                              controller: _code,
                              autofocus: false,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                              ),
                              decoration:InputDecoration(
                                hintText:"verify_email".tr(),
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
                                        ),
                                        Text(countdownTime>0?"${countdownTime}s":'register_hq_yzm'.tr(),style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                        ),)
                                      ],
                                    ),
                                  ),
                                )
                            )
                          ],
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                      child: Text('safe_dlmm'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(24)),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                      child: TextField(
                        controller: _pwd,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText:showPwd,
                        autofocus: false,
                        onChanged: (v)=>{
                          if(!CommonUtil.isEmpty(v)&&isSendCode){
                            this.setState(() { canUnBind= true; })
                          }
                        },
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                        ),
                        decoration:InputDecoration(
                          hintText:"safe_dlmm".tr(),
                            suffixIcon: IconButton(
                              color: Colors.white,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: ImageIcon(AssetImage(showPwd?'res/eye_close.png':'res/eye_open.png')),
                              onPressed: (){
                                setState(() {
                                  showPwd = !showPwd;
                                });
                              },
                            )
                        ),
                      ),
                    ),
                    canUnBind?
                    Padding(
                      child: SizedBox(
                        width: ScreenUtil().setWidth(686),
                        height: ScreenUtil().setHeight(80),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(44),
                          ),
                          padding: EdgeInsets.all(0.0),
                          child: Text('submit'.tr(),style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Future.delayed(Duration(milliseconds: 120), (){
                              _submit();
                            });
                          },
                          elevation: 4.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(80),bottom: ScreenUtil().setHeight(60)),
                    ):
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
            )
        )
    );
  }
}
