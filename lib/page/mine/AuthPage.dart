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
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';


class AuthPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<AuthPage> {
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _code = new TextEditingController();
  final TextEditingController _cardtype = new TextEditingController();

  String card1 = "";
  String card2 = "";
  String card3 = "";

  String card1Upload = "";
  String card2Upload = "";
  String card3Upload = "";


  @override
  void initState() {
    super.initState();
  }


  void showCardTypeDialog(){
    List<Widget> list = [];
    List<String> listCard = ["auth_card_idcard".tr(),"auth_card_hz".tr()];
    for(int i=0;i<listCard.length;i++){
      list.add(SimpleDialogOption(
        child: new Text(listCard[i]),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            _cardtype.text = listCard[i];
          });
        },
      ));
    }
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }

  final picker = ImagePicker();
  Future<void> selectPic(int type) async {
    FocusScope.of(context).requestFocus(FocusNode());
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
                onFinishPhoto(type,1);
                Navigator.of(context).pop();
              },
            ),
            new SimpleDialogOption(
              child: new Text('camera'.tr()),
              onPressed: () {
                onFinishPhoto(type,2);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onFinishPhoto(int type,int isGallery) async {
    var image = await picker.getImage(source: isGallery == 1?ImageSource.gallery:ImageSource.camera,imageQuality:80);
    if(image != null){
      List<int> imageBytes = await image.readAsBytes();
      var baseImg = base64Encode(imageBytes);
      String imageBase = "data:image/png;base64," + baseImg;
      _progressDialog.show();
      var params = {'base64Data':imageBase};
      DioManager.getInstance().post(Url.UPLOAD_BASE64, params, (data){
        String dataStr = json.encode(data);
        Map<String, dynamic> dataMap = json.decode(dataStr);
        setState(() {
          if(type == 1){
            card1 = image.path;
            card1Upload = dataMap['data'];
          }else if(type ==2){
            card2 = image.path;
            card2Upload = dataMap['data'];
          }else if(type ==3){
            card3 = image.path;
            card3Upload = dataMap['data'];
          }
        });
        _progressDialog.hide();
      }, (error){
        _progressDialog.hide();
        CommonUtil.showToast(error);
      });
    }
  }

  _submit() async {
    if(CommonUtil.isEmpty(_lastName.text)){
      CommonUtil.showToast('label_qtx'.tr()+'auth_name'.tr());
      return;
    }
    if(CommonUtil.isEmpty(_cardtype.text)){
      CommonUtil.showToast('label_qtx'.tr()+'auth_cardtype'.tr());
      return;
    }
    if(CommonUtil.isEmpty(_code.text)){
      CommonUtil.showToast('label_qtx'.tr()+'auth_cardnumber'.tr());
      return;
    }
    if(CommonUtil.isEmpty(card1Upload)){
      CommonUtil.showToast('label_qtx'.tr()+'auth_card'.tr());
      return;
    }
    if(CommonUtil.isEmpty(card2Upload)){
      CommonUtil.showToast('label_qtx'.tr()+'auth_card_2'.tr());
      return;
    }
    if(CommonUtil.isEmpty(card3Upload)){
      CommonUtil.showToast('label_qtx'.tr()+'auth_card_3'.tr());
      return;
    }
    _progressDialog.show();
    String type = "";
    if(_cardtype.text == "auth_card_idcard".tr()){
      type = "IDCARD";
    }else if(_cardtype.text == 'auth_card_hz'.tr()){
      type = "PASSPORT";
    }
    var params = {"realName":_lastName.text,"idCardType":type,"idCard":_code.text,"idCardFront":card1Upload,"idCardBack":card2Upload,
    "handHeldIdCard":card3Upload};
    DioManager.getInstance().post(Url.USER_AUTH, params, (data){
      _progressDialog.hide();
      UserData userData = Provider.of<UserInfoState>(context, listen: false).userInfoModel;
      userData.realVerified = 0;
      userData.realAuditing = 1;
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(userData);
      eventBus.fire(new RefreshUserInfo());
      CommonUtil.showToast("auth_success".tr());
      showDalog();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  //认证成功
  void showDalog(){
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('auth_label'.tr()),
          content:Text('auth_label_value'.tr()),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
                _exit();
              },
            ),
          ],
        );
      },
    );
  }

  void _exit(){
    Navigator.of(context).pop();
  }

  Widget _renderIdcard(int type){
    String title = 'auth_card'.tr();
    String subtitle = 'auth_card_value'.tr();
    String defaultImg = 'res/idcard_1.png';
    String card = card1;
    switch(type){
      case 2:
         title = 'auth_card_2'.tr();
         subtitle = 'auth_card_value_2'.tr();
         defaultImg = 'res/id_card2.png';
         card = card2;
        break;
      case 3:
         title = 'auth_card_3'.tr();
         subtitle = 'auth_card_value_3'.tr();
         defaultImg = 'res/id_card3.png';
         card = card3;
        break;
    }

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
        width: double.infinity,
        height: ScreenUtil().setHeight(194),
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Color(0xFF202D49)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(18)),
                  child: Text(title,style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28)),),
                ),
                Text(subtitle,style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24)),)
              ],
            ),
            CommonUtil.isEmpty(card) ? Image.asset(defaultImg,width: ScreenUtil().setWidth(230),height: ScreenUtil().setHeight(126),):
            Image.file(File(card),width: ScreenUtil().setWidth(230),height: ScreenUtil().setHeight(126),)
          ],
        ),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        selectPic(type);
      },
    );
  }


  ProgressDialog _progressDialog;
  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible:false);
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
            title: Text('mine_menu_smrz'.tr()),
          ),
          body: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40)),
              child:CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  new SliverPadding(
                    padding: EdgeInsets.only(top:ScreenUtil().setHeight(0),),
                    sliver: new SliverList(
                      delegate: new SliverChildListDelegate(
                        <Widget>[
                          Container(
                              padding: EdgeInsets.only(top:ScreenUtil().setHeight(58),bottom: ScreenUtil().setHeight(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      'auth_name'.tr(),
                                      style:TextStyle(
                                        fontSize: ScreenUtil().setSp(26),
                                      )
                                  ),
                                ],
                              )
                          ),
                          TextField(
                            controller: _lastName,
                            autofocus: false,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                            ),
                            decoration:InputDecoration(
                              contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(35)),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top:ScreenUtil().setHeight(58),bottom: ScreenUtil().setHeight(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      'auth_cardtype'.tr(),
                                      style:TextStyle(
                                        fontSize: ScreenUtil().setSp(26),
                                      )
                                  ),
                                ],
                              )
                          ),
                          GestureDetector(
                            onTap: (){
                              showCardTypeDialog();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: TextField(
                              controller: _cardtype,
                              enabled:false,
                              autofocus: false,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                              ),
                              decoration:InputDecoration(
                                  suffixIcon:Container(
                                    child:  Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
                                  )
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top:ScreenUtil().setHeight(58),bottom: ScreenUtil().setHeight(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      'auth_cardnumber'.tr(),
                                      style:TextStyle(
                                        fontSize: ScreenUtil().setSp(26),
                                      )
                                  ),
                                ],
                              )
                          ),
                          TextField(
                            controller: _code,
                            autofocus: false,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                            ),
                            decoration:InputDecoration(
                              contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(35)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(24)),
                            child: Row(
                              children: <Widget>[
                                Image.asset('res/label.png',width: ScreenUtil().setWidth(32),height: ScreenUtil().setWidth(32),),
                                Padding(
                                  child:Text('auth_labelcard'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24))),
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                )
                              ],
                            ),
                          ),
                          _renderIdcard(1),
                          _renderIdcard(2),
                          _renderIdcard(3),

                          Container(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(100)),
                            child: Center(
                                child:SizedBox(
                                  width: ScreenUtil().setWidth(670),
                                  height: ScreenUtil().setHeight(80),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(44),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    child: Text('submit'.tr(),style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      _submit();
                                    },
                                    elevation: 4.0,
                                  ),
                                )
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )),
        )
    );
  }
}
