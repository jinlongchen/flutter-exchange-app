import 'dart:async';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'LoginPage.dart';

typedef VoidSuccessCallback = dynamic Function(String v);

class RegisterEmailPage extends StatefulWidget {
  final VoidSuccessCallback onChange;

  const RegisterEmailPage({Key key, this.onChange}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<RegisterEmailPage> with TickerProviderStateMixin {
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _code = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _passwordAgain = new TextEditingController();
  final TextEditingController _inviteCode = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //定义变量
  Timer _timer;
  //倒计时数值
  var countdownTime = 0;


  bool isVisiblePwd1 = true;
  bool isVisiblePwd2 = true;

  String country = '中国';

  @override
  void initState() {
    super.initState();
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

  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.infinity;
  double _width_default ;

  setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "register".tr(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Text(
        "register".tr(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    }
  }

  void resetButton(){
    double initialWidth = _globalKey.currentContext.size.width;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth + ((_width_default - 50.0) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 0;
    });
  }

  void changePasswordVisibile(int type){
    if(type ==1){
      setState(() {
        isVisiblePwd1 = !isVisiblePwd1;
      });
    }else{
      setState(() {
        isVisiblePwd2 = !isVisiblePwd2;
      });
    }
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
    DioManager.getInstance().post(Url.EMAIL_SEND, params, (data){
      _progressDialog.hide();
      startCountdown();
      final snackBar = SnackBar(
        content: Text('register_send_success'.tr()),
        action: SnackBarAction(
          label: 'label_undo'.tr(),
          onPressed: () {
            // Some code to undo the change.
          },
        ),);
      Scaffold.of(context).showSnackBar(snackBar);
    }, (error){
      CommonUtil.showToast(error);
      _progressDialog.hide();
    });
  }

  void register(){
    if(CommonUtil.isEmpty(_username.text)){
      CommonUtil.showToast("label_qsryx".tr());
      return;
    }
    if(CommonUtil.isEmpty(_code.text)){
      CommonUtil.showToast("register_code_match".tr());
      return;
    }
    if(CommonUtil.isEmpty(_inviteCode.text)){
      CommonUtil.showToast("label_qsryqm".tr());
      return;
    }

    if(_password.text != _passwordAgain.text){
      CommonUtil.showToast("lbbel_pwdagain".tr());
      return;
    }

    double initialWidth = _globalKey.currentContext.size.width;
    _width_default =  _globalKey.currentContext.size.width;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 50.0) * _animation.value);
        });
      });
    _controller.forward();
    setState(() {
      _state = 1;
    });
    var params={"email":_username.text,"code":_code.text,"promotion":_inviteCode.text,"username":_username.text,"password":CommonUtil.generateMd5(_password.text),
    "country":country};

    DioManager.getInstance().post(Url.EMAIL_REGISTER, params, (data){
      CommonUtil.showToast('success'.tr());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    }, (error){
      CommonUtil.showToast(error);
      resetButton();
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
    return new Container(
        color: Colours.dark_bg_gray,
        child: Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40)),
              child:Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                    child: Text(
                      'register_mail'.tr(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(52),color: Colours.dark_text_gray,fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                      child: TextField(
                        controller: _username,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                        ),
                        decoration:InputDecoration(
                          hintText:"regitser_mail".tr(),
                          hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                          )
                        ),
                      ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                      child: Stack(
                        children: <Widget>[
                          TextField(
                            controller: _code,
                            autofocus: false,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(32),
                            ),
                            decoration:InputDecoration(
                              hintText:"verify_email".tr(),
                              contentPadding:EdgeInsets.only(right: ScreenUtil().setWidth(150)),
                                hintStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(32),
                                )
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
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                    child: TextFormField(
                      controller: _password,
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText:isVisiblePwd1,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                      ),
                      decoration:InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                          ),
                          hintText: "login_password".tr(),
                          suffixIcon: GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(14),
                                child: Image.asset(isVisiblePwd1?'res/eye_close.png':'res/eye_open.png',width: ScreenUtil().setWidth(28),height: ScreenUtil().setHeight(20),)
                            ),
                            onTap: (){changePasswordVisibile(1);},
                          )
                      ),
                      validator: (value) {
                        Pattern pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                        RegExp reg = new RegExp(pattern);
                        if (!reg.hasMatch(value)) {
                          return 'register_pwd_match'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                    child: TextFormField(
                      controller: _passwordAgain,
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText:isVisiblePwd2,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                      ),
                      decoration:InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                          ),
                          hintText: "register_password_agin".tr(),
                          suffixIcon: GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(14),
                                child: Image.asset(isVisiblePwd2?'res/eye_close.png':'res/eye_open.png',width: ScreenUtil().setWidth(28),height: ScreenUtil().setHeight(20),)
                            ),
                            onTap: (){changePasswordVisibile(2);},
                          )
                      ),
                      validator: (value) {
                        Pattern pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                        RegExp reg = new RegExp(pattern);
                        if (!reg.hasMatch(value)) {
                          return 'register_pwd_match'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                    child: TextField(
                      controller: _inviteCode,
                      autofocus: false,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                      ),
                      decoration:InputDecoration(
                        hintText: "register_invitate".tr(),
                        hintStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(80),bottom: ScreenUtil().setHeight(40)),
                    child: PhysicalModel(
                      elevation: 4.0,
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(28.0)),
                      child: Container(
                        key: _globalKey,
                        height: 50.0,
                        width: _width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: EdgeInsets.all(0.0),
                          child: setUpButtonChild(),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              register();
                            }
                          },
                          elevation: 4.0,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            child: Image.asset('res/register_change.png',width: ScreenUtil().setWidth(24),height: ScreenUtil().setHeight(20),),
                            padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                          ),
                          GestureDetector(
                            child: Text(
                              'change_pwd'.tr(),
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: Color(0xFF1A72CE),
                              ),
                            ),
                            onTap: (){
                              this.widget.onChange('1');
                            },
                          )
                        ],
                      )
                    ],
                  )
                ],
              )
          ),
        )
    );
  }
}
