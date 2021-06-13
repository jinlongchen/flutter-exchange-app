import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

import 'AssetsSeachPage.dart';

class AssetsDepositPage extends StatefulWidget {
  final MoneyListDataData item;

  const AssetsDepositPage({Key key, this.item}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<AssetsDepositPage> {
  String code = "";
  String address = "";
  String chargeMoneyHint = "";
  GlobalKey repaintKey =new GlobalKey();


  @override
  void initState() {
    super.initState();
    if(widget.item != null){
      setState(() {
        code = widget.item.coin.name;
        address = CommonUtil.isEmpty(widget.item.address)?'':widget.item.address;
        chargeMoneyHint = CommonUtil.isEmpty(widget.item.coin.chargeMoneyHint)?"":widget.item.coin.chargeMoneyHint;
      });
    }else{
      CommonUtil.showToast('请选择币种');
      Future.delayed(Duration(seconds: 1),(){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AssetsSeachPage(type: 'deposit',);
        })).then((value) => setState((){
          MoneyListDataData item = value;
          if(item == null){
            return;
          }
          setState(() {
            code = item.coin.name;
            address = CommonUtil.isEmpty(item.address)?'':item.address;
            chargeMoneyHint = CommonUtil.isEmpty(item.coin.chargeMoneyHint)?'':item.coin.chargeMoneyHint;
          });
        }));
      });
    }
  }


  int qrBg = 0;

  takeScreenShot() async{
    _progressDialog.show();
    setState(() {
      qrBg = 1;
    });
    Future.delayed(Duration(seconds: 1),() async {
      RenderRepaintBoundary boundary = repaintKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print(pngBytes.toString());
      final result = await ImageGallerySaver.saveImage(pngBytes,quality: 100);
      CommonUtil.showToast("invite_success".tr());
      setState(() {
        qrBg = 0;
      });
      _progressDialog.hide();
    });

  }


  ProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context){
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
      backgroundColor: Color(0xff1B2438),
      appBar: AppBar(
        leading: AppBarReturn(),
        centerTitle: false,
        title: Text('deposit'.tr()),
      ),
      body: SingleChildScrollView(
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
                    address = CommonUtil.isEmpty(item.address)?'':item.address;
                    chargeMoneyHint = CommonUtil.isEmpty(item.coin.chargeMoneyHint)?'':item.coin.chargeMoneyHint;
                  });
                }));
              },
            ),
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(716),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40)),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(666),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("res/bg_deposit.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        CommonUtil.isEmpty(address)?
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          width: ScreenUtil().setWidth(300),
                          height: ScreenUtil().setWidth(300),
                        ):
                        RepaintBoundary(
                          key: repaintKey,
                          child:  Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                            decoration: BoxDecoration(
                                color: Colors.white,
                            ),
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setWidth(300),
                            child: QrImage(
                              foregroundColor:Colors.black,
                              size: ScreenUtil().setWidth(300),
                              data: address,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(40)),
                          child:Text('deposit_qrcode'.tr(),style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24)),),
                        ),
                        Text('depositAddress'.tr(),style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(28)),),
                        Padding(
                          child:Text(address,style: TextStyle(color: Colors.white,fontFamily:'Din',fontSize: ScreenUtil().setSp(24)),),
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                width: ScreenUtil().setHeight(100),
                                height: ScreenUtil().setHeight(100),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  boxShadow: [BoxShadow(color: Color(0x99000000), offset: Offset(5.0, 5.0),    blurRadius: 5.0, spreadRadius: 2.0), BoxShadow(color: Color(0x99000000), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF000000))],
                                ),
                                child: Center(
                                  child: Image.asset('res/deposit_download.png',width: ScreenUtil().setWidth(34),height: ScreenUtil().setHeight(36),),
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                Map<Permission, PermissionStatus> statuses = await [
                                  Permission.storage,
                                ].request();

                                if (statuses[Permission.storage] == PermissionStatus.granted) {
                                  takeScreenShot();
                                }
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil().setHeight(86)),
                                width: ScreenUtil().setHeight(100),
                                height: ScreenUtil().setHeight(100),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  boxShadow: [BoxShadow(color: Color(0x99000000), offset: Offset(5.0, 5.0),    blurRadius: 5.0, spreadRadius: 2.0), BoxShadow(color: Color(0x99000000), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF000000))],
                                ),
                                child: Center(
                                  child: Image.asset('res/deposit_copy.png',width: ScreenUtil().setWidth(34),height: ScreenUtil().setHeight(36),),
                                ),
                              ),
                              onTap: (){
                                ClipboardData data = new ClipboardData(text:address);
                                Clipboard.setData(data);
                                CommonUtil.showToast("copy_success".tr());
                              },
                              behavior: HitTestBehavior.opaque,
                            )
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
            Card(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(90)),
                elevation: 2.0,  //设置阴影
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),  //设置圆角
                child: Container(
                  width: double.infinity,
                  color: Color(0xff202d49),
                  child: Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(40)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(chargeMoneyHint,style: TextStyle(
                            color: Color(0xFF9496A2),fontSize: ScreenUtil().setSp(24)
                          ),),
                        ],
                      )
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}
