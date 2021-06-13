import 'dart:async';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/model/login_entity.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/page/mine/SafeAccountPwdPage.dart';
import 'package:hibi/page/mine/SafeEmailPage.dart';
import 'package:hibi/page/mine/SafePhonePage.dart';
import 'package:hibi/page/mine/SafePwdPage.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'SafeAccountPwdResetPage.dart';

class SafeSettingPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<SafeSettingPage> {
  UserData user = new UserData();

  StreamSubscription  _sub3;

  @override
  void initState() {
    super.initState();
    getUser();
    _sub3 = eventBus.on<RefreshUserInfo>().listen((event) {
      getUser();
    });
  }

  @override
  void dispose() {
    _sub3.cancel();
    super.dispose();
  }

  void getUser(){
    UserData data = Provider.of<UserInfoState>(context, listen: false).userInfoModel;
    setState(() {
      user = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
      ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(60),left: ScreenUtil().setWidth(32)),
                child: Text('mine_menu_aqsz'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(38)),),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(58)),
                height: ScreenUtil().setHeight(59),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: CommonUtil.isDark(context)?Colours.dark_line : Colours.line,))
                ),
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                  child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(110),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('regitser_mail'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(29)),),
                        Container(
                          padding: EdgeInsets.only(right: ScreenUtil().setWidth(32)),
                          child: Row(
                            children: <Widget>[
                              Text(CommonUtil.isEmpty(user.email)?'safe_bd'.tr():user.email,style: TextStyle(color: CommonUtil.isEmpty(user.email)?Theme.of(context).accentColor:Colours.dark_text,fontSize: ScreenUtil().setSp(24)),),
                              Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                            ],
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: CommonUtil.isDark(context)?Colours.dark_line : Colours.line,))
                    ),
                  ),
                ),
                onTap: (){
                  if(CommonUtil.isEmpty(user.email)){
                    Future.delayed(Duration(milliseconds: Config.delayedTime), (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SafeEmailPage();
                      }));
                    });
                  }
                },
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(110),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('register_tel'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(29)),),
                      Container(
                        padding: EdgeInsets.only(right: ScreenUtil().setWidth(32)),
                        child: Row(
                          children: <Widget>[
                            Text(CommonUtil.isEmpty(user.mobilePhone)?'safe_bd'.tr():user.mobilePhone,style: TextStyle(color: CommonUtil.isEmpty(user.mobilePhone)?Theme.of(context).accentColor:Colours.dark_text,fontSize: ScreenUtil().setSp(24)),),
                            Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color:  CommonUtil.isDark(context)?Colours.dark_line : Colours.line,))
                  ),
                ),
                onTap: (){
                  if(CommonUtil.isEmpty(user.mobilePhone)){
                    Future.delayed(Duration(milliseconds: Config.delayedTime), (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SafePhonePage();
                      }));
                    });
                  }
                },
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(110),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('safe_dlmm'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(29)),),
                      Container(
                        padding: EdgeInsets.only(right: ScreenUtil().setWidth(32)),
                        child: Row(
                          children: <Widget>[
                            Text('safe_update'.tr(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: ScreenUtil().setSp(24)),),
                            Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: CommonUtil.isDark(context)?Colours.dark_line : Colours.line,))
                  ),
                ),
                onTap: (){
                  if(CommonUtil.isEmpty(user.mobilePhone)){
                    CommonUtil.showToast('label_qxbdsjh'.tr());
                  }else{
                    Future.delayed(Duration(milliseconds: Config.delayedTime), (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SafePwdPage();
                      }));
                    });
                  }
                },
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(110),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('safe_zjmm'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(29)),),
                      Container(
                        padding: EdgeInsets.only(right: ScreenUtil().setWidth(32)),
                        child: Row(
                          children: <Widget>[
                            Text(user.fundsVerified == 0?'safe_bd'.tr():'safe_update'.tr(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: ScreenUtil().setSp(24)),),
                            Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: CommonUtil.isDark(context)?Colours.dark_line : Colours.line,))
                  ),
                ),
                onTap: (){
                  if(CommonUtil.isEmpty(user.mobilePhone)){
                    CommonUtil.showToast('label_qxbdsjh'.tr());
                  }else{
                    Future.delayed(Duration(milliseconds: Config.delayedTime), (){
                      if(user.fundsVerified == 0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SafeAccountPwdPage();
                        }));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SafeAccountPwdResetPage();
                        }));
                      }
                    });
                  }
                },
              ),
            ],
          ),
        )
    );
  }
}
