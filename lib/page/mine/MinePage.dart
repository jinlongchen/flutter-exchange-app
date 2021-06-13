import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/model/version_entity.dart';
import 'package:hibi/page/mine/AuthPage.dart';
import 'package:hibi/page/mine/SafeSettingPage.dart';
import 'package:hibi/page/trading/OrderListPage.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_zendesk_support/flutter_zendesk_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../WebPage.dart';

class MinePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MinePage> {

  UserData user = new UserData();


  StreamSubscription  _sub3;

  @override
  void initState() {
    super.initState();
   getUserData();
    _sub3 = eventBus.on<RefreshUserInfo>().listen((event) {
      getUserData();
    });
    updateUser();
    getRank();
  }

  String initialBadge = '';
  String initialBadgeText = '';
  String badgeAddress = '';
  String badgeAddressText = '';

  void getRank(){
    DioManager.getInstance().post("/rank/total/icon", null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      if(dataMap['data'] != null){
        String initialBadge1 = dataMap['data']['initialBadge'];
        String badgeAddress2 = dataMap['data']['badgeAddress'];
        if(!CommonUtil.isEmpty(initialBadge1)){
          setState(() {
            initialBadge = initialBadge1;
            initialBadgeText = dataMap['data']['initialDescribe'];
          });
        }
        if(!CommonUtil.isEmpty(badgeAddress2)){
          setState(() {
            badgeAddress = badgeAddress2;
            badgeAddressText = dataMap['data']['badgeDescribe'];
          });
        }
      }
    }, (error){

    });
  }

  @override
  void dispose() {
    _sub3.cancel();
    super.dispose();
  }

  void updateUser() {
    DioManager.getInstance().post(Url.USER_INFO, null, (data2){
      UserEntity userEntity = JsonConvert.fromJsonAsT(data2);
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(userEntity.data);
      setState(() {
        user = userEntity.data;
      });
    }, (error){

    });
  }

  void getUserData(){
    UserData data = Provider.of<UserInfoState>(context, listen: false).userInfoModel;
    setState(() {
      user = data;
    });
  }

  final picker = ImagePicker();

  Future<void> selectPhoto() async {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          backgroundColor: Colours.dark_bg_gray,
          title: new Text('please_select'.tr()),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('photo'.tr()),
              onPressed: () {
                onFinishPhoto(1);
                Navigator.of(context).pop();
              },
            ),
            new SimpleDialogOption(
              child: new Text('camera'.tr()),
              onPressed: () {
                onFinishPhoto(2);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onFinishPhoto(int type) async{
    var image = await picker.getImage(source: type == 1?ImageSource.gallery:ImageSource.camera,imageQuality:70);
    if(image != null){
      List<int> imageBytes = await image.readAsBytes();
      var baseImg = base64Encode(imageBytes);
      String imageBase = "data:image/png;base64," + baseImg;
      upLoadAvatar(imageBase);
    }
  }

  Future<void> upLoadAvatar(String base64) async{
    _progressDialog.show();
    var params = {'base64Data':base64};
    DioManager.getInstance().post(Url.UPLOAD_BASE64, params, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      updateAvatar(dataMap['data']);
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  Future<void> updateAvatar(String url) async{
    var params = {'url':url};
    DioManager.getInstance().post(Url.USER_BIND_AVATAR, params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success');
      UserData data = Provider.of<UserInfoState>(context, listen: false).userInfoModel;
      data.avatar = url;
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(data);
      setState(() {
        user = data;
      });
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }


  final List menuDatas = [
    {
      'icon':'res/user_jyjl.png',
      'title':'mine_menu_jyjl'.tr(),
    },
    {
      'icon':'res/user_aqsz.png',
      'title':'mine_menu_aqsz'.tr(),
    },
    {
      'icon':'res/user_sfrz.png',
      'title':'mine_menu_smrz'.tr(),
    },
    {
      'icon':'res/mine_lxkf.png',
      'title':'联系客服',
    },
    {
      'icon':'res/user_gywm.png',
      'title':'mine_menu_gywm'.tr(),
    },
    {
      'icon':'res/user_bbxx.png',
      'title':'mine_menu_bbgx'.tr(),
    },
  ];

  Future<void> onClick(int index) async {
    switch(index){
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderListPage();
        }));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SafeSettingPage();
        }));
        break;
      case 2:
        if(user.realVerified == 0 && user.realAuditing != 1){
          if(user.realNameRejectReason != null){
            showAuthFailDialog();
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AuthPage();
            }));
          }
        }
        break;
      case 3:
        await FlutterZendeskSupport.openTickets();
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WebPage(url: "https://HiBisupporthelp.zendesk.com/hc/zh-cn/articles/360001902996-%E5%85%B3%E4%BA%8E%E6%88%91%E4%BB%AC",);
        }));
        break;
      case 5:
        getConfig();
        break;
    }
  }

  void getConfig(){
    _progressDialog.show();
    String url = '';
    if(Platform.isAndroid){
      url = "/uc/app/info/android/version";
    }else{
      url = "/uc/app/info/iPhone/version";
    }
    DioManager.getInstance().post(url, null, (data){
      _progressDialog.hide();
      VersionEntity versionEntity = JsonConvert.fromJsonAsT(data);
      int code = int.tryParse(versionEntity.data.versionCode);
      if(code > Config.VERSION_CODE){
        showUpdateDialog(versionEntity.data.isUpdate == 1 ?true:false, versionEntity.data.description,versionEntity.data.url);
      }else{
        CommonUtil.showToast("已经是最新版本");
      }
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
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

  void showAuthFailDialog(){
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('auth_failed'.tr()),
          content:Text(user.realNameRejectReason),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AuthPage();
                }));
              },
            ),
          ],
        );
      },
    );
  }

  void exitLogin(){
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B2438),
          title: Text('label_tip'.tr()),
          content:Text('label_exit_login'.tr()),
          actions: <Widget>[
            FlatButton(
              child: Text('cancel'.tr(),style: TextStyle(
                color: Theme.of(context).accentColor
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('ok'.tr(),style: TextStyle(
                  color: Theme.of(context).accentColor
              ),),
              onPressed: () {
                exit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> exit() async {
    Provider.of<UserInfoState>(context, listen: false).updateUserInfo(null);
    SpUtil.putString(Config.token, "");
    Navigator.of(context).pop();
  }

  Widget renderAuthStatus(){
    if(user.realVerified == 0){
      if(user.realAuditing == 1){
        return Text('status_shz'.tr());
      }else{
        if(user.realNameRejectReason != null){
          return Text('status_shsb'.tr());
        }else{
          return Icon(Icons.keyboard_arrow_right,color: Colors.grey);
        }
      }
    }else{
      return Text('status_hasAuth'.tr());
    }
  }

  Widget _renderItem(int index){
    return InkWell(
        onTap: (){
          onClick(index);
        },
        child: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(116),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ImageIcon(AssetImage(menuDatas[index]['icon']),size: ScreenUtil().setWidth(35),),
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                          child:Text(menuDatas[index]['title']),
                        )
                      ],
                    ),
                    index == 2 ? Padding(
                      child: renderAuthStatus(),
                      padding: EdgeInsets.only(right: ScreenUtil().setWidth(7)),
                    ):
                    Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                  ],
                ),
              ),
              Divider(height: 1.0,
                indent: 0.0,),
            ],
          ),
        )
    );
  }

  void showRank(String text){
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B2438),
          content:Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'.tr(),style: TextStyle(
                  color: Theme.of(context).accentColor
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible:false);
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

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colours.dark_bg_gray),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(436),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(320),
                    padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("res/user_center_bg.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                          ],
                        )
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Card(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                      elevation: 6.0,  //设置阴影
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(228),
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40)),
                        color: Colours.dark_bg_gray,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  new ClipOval(
                                    child:  CommonUtil.isEmpty(user.avatar)?Image.asset('res/avatar.png',width: ScreenUtil().setWidth(139),height: ScreenUtil().setWidth(139),):
                                    CachedNetworkImage(imageUrl: user.avatar,width: ScreenUtil().setWidth(139),height: ScreenUtil().setWidth(139),fit: BoxFit.fill,),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child:  Image.asset('res/avatar_edit.png',width: ScreenUtil().setWidth(44),height: ScreenUtil().setWidth(44),),
                                  )
                                ],
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                selectPhoto();
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Hi,'+user.username,style: TextStyle(color: Colors.white,fontFamily: 'Din',fontSize: ScreenUtil().setSp(40)),),
                                  Padding(
                                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10)),
                                    child:Text('UID '+user.id.toString(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontFamily: 'Din',fontSize: ScreenUtil().setSp(28)),),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      CommonUtil.isEmpty(badgeAddress)?Container():
                                          GestureDetector(
                                            onTap: (){
                                              showRank(badgeAddressText);
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: badgeAddress,
                                              width: ScreenUtil().setWidth(35),
                                              height: ScreenUtil().setWidth(35),
                                            ),
                                          ),
                                      CommonUtil.isEmpty(initialBadge)?Container():
                                        Padding(
                                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                                          child: GestureDetector(
                                            onTap: (){
                                              showRank(initialBadgeText);
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: initialBadge,
                                              width: ScreenUtil().setWidth(35),
                                              height: ScreenUtil().setWidth(35),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
            ),
            _renderItem(0),
            _renderItem(1),
            _renderItem(2),
            _renderItem(3),
            _renderItem(4),
            _renderItem(5),

            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(160),left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
              width: double.infinity,
              height: ScreenUtil().setHeight(88),
              child: RaisedButton(
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                color: Theme.of(context).accentColor,
                child: Text("mine_exit".tr()),
                onPressed: () {
                  exitLogin();
                },
              ),
            )
          ],
        ),
      ),
    );


  }

}
