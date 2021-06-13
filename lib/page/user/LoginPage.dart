import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/login_entity.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/page/user/ForgetPwdPage.dart';
import 'package:hibi/page/user/RegisterPage.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<LoginPage> with TickerProviderStateMixin  {

  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  bool showPwd = true;

  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.infinity;
  double _width_default ;

  @override
  void initState() {
    super.initState();
  }

  setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "login".tr(),
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
        "login".tr(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    }
  }

  login(){
    var params = {"username":_username.text,"password":CommonUtil.generateMd5(_password.text)};
    DioManager.getInstance().post(Url.LOGIN, params, (data) async {
      LoginEntity loginEntity = JsonConvert.fromJsonAsT(data);
      SpUtil.putString(Config.token, loginEntity.data.token);
      DioManager.getInstance().post(Url.USER_INFO, null, (data2){
        UserEntity userEntity = JsonConvert.fromJsonAsT(data2);
        Provider.of<UserInfoState>(context, listen: false).updateUserInfo(userEntity.data);
        Navigator.of(context).pop();
        eventBus.fire(new RefreshAsstes());
      }, (error){
        CommonUtil.showToast(error);
        resetButton();
      });
    }, (err){
      CommonUtil.showToast(err);
      resetButton();
    });
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(898),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("res/login.gif"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child:Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                        height: 56.0,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(12),right: ScreenUtil().setWidth(32)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: ImageIcon(
                                AssetImage('res/return.png'),
                                size: ScreenUtil().setWidth(32),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            GestureDetector(
                              child:  Container(
                                width: ScreenUtil().setWidth(100),
                                height: 56.0,
                                alignment: Alignment.centerRight,
                                child: Text('register'.tr(),style: TextStyle(color: Color(0xFFE0E0E7),fontSize: ScreenUtil().setSp(32)),),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                  return RegisterPage();
                                }));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(938),
                        decoration: BoxDecoration(
                          color: Color(0xff1b2438),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(ScreenUtil().setWidth(40)),topLeft: Radius.circular(ScreenUtil().setWidth(40))),
                          boxShadow: [BoxShadow(color: Color(0x80000000), offset: Offset(0.0, -8.0),blurRadius: 48.0, spreadRadius: 0.0), BoxShadow(color: Color(0xFF000000))],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(100)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('login'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(52),fontWeight: FontWeight.w500),),
                              Padding(
                                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                                  child:Text('home_welcome'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(32)),)
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                                child: TextField(
                                  controller: _username,
                                  autofocus: false,
                                  style: TextStyle(
                                    color:Colors.white,
                                    fontFamily: 'Din',
                                    fontSize: ScreenUtil().setSp(32),
                                  ),
                                  decoration:InputDecoration(
                                    labelText: "login_username".tr(),
                                    labelStyle: TextStyle(color: Color(0xFF9496A2)),
                                    contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(0),),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                                child: TextField(
                                  controller: _password,
                                  autofocus: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText:showPwd,
                                  style: TextStyle(
                                    color:Colors.white,
                                    fontFamily: 'Din',
                                    fontSize: ScreenUtil().setSp(32),
                                  ),
                                  decoration:InputDecoration(
                                      labelText: "login_password".tr(),
                                      labelStyle: TextStyle(color: Color(0xFF9496A2)),
                                      contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(5),),
                                      suffixIcon:GestureDetector(
                                        child: Container(
                                            padding: EdgeInsets.all(14),
                                            child: Image.asset(showPwd?'res/eye_close.png':'res/eye_open.png',width: ScreenUtil().setWidth(28),height: ScreenUtil().setHeight(20),)
                                        ),
                                        onTap: (){
                                          setState(() {
                                            showPwd = !showPwd;
                                          });
                                        },
                                      )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                child:  GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text('forget_password'.tr()+"?",style: TextStyle(color: Color(0xff1A72CE),fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w400),)
                                    ],
                                  ),
                                  behavior: HitTestBehavior.opaque,
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return ForgetPwdPage();
                                    }));
                                  },
                                )
                              ),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(80),bottom: ScreenUtil().setHeight(40)),
                                      child: PhysicalModel(
                                        color: CommonUtil.isDark(context)?Colours.dark_bg_color:Colours.bg_color,
                                        elevation: 4.0,
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
                                              if(CommonUtil.isEmpty(_username.text)){
                                                CommonUtil.showToast('label_qsrzh'.tr());
                                                return;
                                              }
                                              if(CommonUtil.isEmpty(_password.text)){
                                                CommonUtil.showToast('label_qsrmm'.tr());
                                                return;
                                              }
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              if (_state == 0) {
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
                                              }
                                              login();
                                            },
                                            elevation: 4.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}
