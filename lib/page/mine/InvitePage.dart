import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/invite_info_entity.dart';
import 'package:hibi/model/invite_list_entity.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/page/mine/AuthPage.dart';
import 'package:hibi/page/mine/SafeSettingPage.dart';
import 'package:hibi/page/trading/OrderListPage.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sp_util/sp_util.dart';
import 'dart:ui' as ui;


class InvitePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<InvitePage> {

  String codeAddress = "";
  String code = "";
  String inviteCount = '';
  int _page = 1;
  bool hasMore = true;
  bool isLoad = false;

  List<InviteListDataData> data = [];
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && hasMore) {
        _onLoading();
      }
    });
    getInviteInfo();
    _onRefresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _onRefresh() async  {
    setState(() {
      _page = 1;
    });
    var params ={'pageNo':1,'pageSize':"40",};
    DioManager.getInstance().post(Url.INVITE_LIST, params, (data2) async {
      InviteListEntity invitelist = JsonConvert.fromJsonAsT(data2);
      setState(() {
        data = invitelist.data.data;
        inviteCount = invitelist.data.total.toString();
        if(invitelist.data.total <= 1 * 40){
          setState(() {
            hasMore = false;
          });
        }else{
          _page = 2;
        }
      });

    }, (error){
      CommonUtil.showToast(error);
    });
  }

  Future _onLoading() async {
    if(isLoad){
      return;
    }
    setState(() {
      isLoad = true;
    });
    var params ={'pageNo':_page,'pageSize':"40",};
    DioManager.getInstance().get(Url.INVITE_LIST, params, (data2) async {
      InviteListEntity invitelist = JsonConvert.fromJsonAsT(data2);
      setState(() {
        data.addAll(invitelist.data.data);
        if(invitelist.data.total <= _page * 40){
          setState(() {
            hasMore = false;
          });
        }else{
          _page = _page+1;
        }
        setState(() {
          isLoad = false;
        });
      });
    }, (error){
      CommonUtil.showToast(error);
      setState(() {
        isLoad = false;
      });
    });
  }

  void getInviteInfo() {
    DioManager.getInstance().post(Url.INVITE_INFO, null, (data2){
      InviteInfoEntity inviteInfo = JsonConvert.fromJsonAsT(data2);
      setState(() {
        code = inviteInfo.data.promotionCode;
        codeAddress = inviteInfo.data.promotionPrefix+inviteInfo.data.promotionCode;
      });
    }, (error){

    });
  }


  Future<ui.Image> loadImage(var path, bool isUrl) async {
    ImageStream stream;
    if (isUrl) {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(path, bundle: rootBundle)
          .resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(ImageStreamListener(listener));
    }

    stream.addListener(ImageStreamListener(listener));
    return completer.future;
  }

  Uint8List imageMemory;

  Future<void> savePic() async {
    var pictureRecorder = new ui.PictureRecorder(); // 图片记录仪
    var canvas = new Canvas(pictureRecorder); //canvas接受一个图片记录仪
    var images = await loadImage(picSelect == 0 ? 'res/invite_pic1.png':'res/invite_pic2.png',false); // 使用方法获取Unit8List格式的图片
    Paint _linePaint = new Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30.0;
    canvas.drawImage(images, Offset(0, 0), _linePaint); // 直接画图
    var qr = await toQrImageData(codeAddress);
    canvas.drawImage(qr, Offset(images.width.toDouble()-250, images.height.toDouble()-230), _linePaint);
    var picture = await pictureRecorder.endRecording().toImage(1125, 2001);//设置生成图片的宽和高
    var pngImageBytes = await picture.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = pngImageBytes.buffer.asUint8List();
    var result = await ImageGallerySaver.saveImage(pngBytes,quality: 100);
    CommonUtil.showToast("invite_success".tr());
  }

  Future<ui.Image> toQrImageData(String text) async {
    var image = await QrPainter(
      data: text,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor:Colors.white,
    ).toImage(200);
    return image;
  }


  int picSelect = 0;

  Future<void> showPicDialog() async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colours.dark_bg_gray,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context2,StateSetter setState){
              return AnimatedPadding(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(1068),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(140),
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('invite_make'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(40)),),
                            GestureDetector(
                              child: Image.asset('res/close.png',width: ScreenUtil().setWidth(32),height: ScreenUtil().setWidth(32),),
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(42),bottom: ScreenUtil().setHeight(42)),
                        width: double.infinity,
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Image.asset('res/invite_pic1.png',width: ScreenUtil().setWidth(328),height: ScreenUtil().setHeight(580),),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child:Image.asset(picSelect == 0 ? 'res/invite_pic_select_p.png':'res/invite_pic_select.png',width: ScreenUtil().setWidth(32),height: ScreenUtil().setHeight(32),),
                                  ),
                                ],
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                setState(() {
                                  picSelect = 0;
                                });
                              },
                            ),
                            GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Image.asset('res/invite_pic2.png',width: ScreenUtil().setWidth(328),height: ScreenUtil().setHeight(580),),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child:Image.asset(picSelect == 1 ? 'res/invite_pic_select_p.png':'res/invite_pic_select.png',width: ScreenUtil().setWidth(32),height: ScreenUtil().setHeight(32),),
                                  ),
                                ],
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                setState(() {
                                  picSelect = 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(10),
                        color: Color(0xFF171A22),
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(32)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset('res/invite_save.png',width: ScreenUtil().setWidth(100),height: ScreenUtil().setHeight(100),),
                              Padding(
                                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                                  child:Text('save_pic'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24)),)
                              ),
                            ],
                          ),
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          Navigator.of(context).pop();
                          Map<Permission, PermissionStatus> statuses = await [
                          Permission.storage,
                          ].request();

                          if (statuses[Permission.storage] == PermissionStatus.granted) {
                            savePic();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }


  TextStyle tvTitlesub = TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24));
  TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din');

  ProgressDialog _progressDialog;

  Widget _getItem(int index){
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(80),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(78),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(data[index].createTime,style: tvTitle,),
                    ],
                  ),
                ),
                Expanded(
                  flex:5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(data[index].username,style: tvTitle,),
                    ],
                  ),
                ),
                Expanded(
                  flex:4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(data[index].realNameStatus == 0?'auth_none'.tr():"auth_has".tr(),style: tvTitle,),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }

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
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(780),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(702),
                      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("res/invite_bg.png"),
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
                            height: ScreenUtil().setHeight(334),
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40)),
                            color: Colours.dark_bg_gray,
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    width: double.infinity,
                                    height: ScreenUtil().setHeight(112),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('invite_mycode'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                                              child:Text(code,style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Colours.dark_text_gray),),
                                            ),
                                            Image.asset('res/invite_copy.png',width: ScreenUtil().setWidth(20),height: ScreenUtil().setWidth(20),)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  behavior: HitTestBehavior.opaque,
                                  onTap: (){
                                    ClipboardData data = new ClipboardData(text:code);
                                    Clipboard.setData(data);
                                    CommonUtil.showToast("copy_success".tr());
                                  },
                                ),
                                Divider(height: ScreenUtil().setHeight(2),),
                                GestureDetector(
                                  child: Container(
                                    width: double.infinity,
                                    height: ScreenUtil().setHeight(112),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('invite_mycodeaddress'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                                              child:Text(CommonUtil.isEmpty(codeAddress)?'':codeAddress.substring(0,20)+'...',maxLines:1,style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Colours.dark_text_gray),),
                                            ),
                                            Image.asset('res/invite_copy.png',width: ScreenUtil().setWidth(20),height: ScreenUtil().setWidth(20),)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  behavior: HitTestBehavior.opaque,
                                  onTap: (){
                                    ClipboardData data = new ClipboardData(text:codeAddress);
                                    Clipboard.setData(data);
                                    CommonUtil.showToast("copy_success".tr());
                                  },
                                ),
                                Container(
                                  width: double.infinity,
                                  height: ScreenUtil().setHeight(108),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                 /*     Container(
                                        width: ScreenUtil().setWidth(288),
                                        height: ScreenUtil().setHeight(68),
                                        child: RaisedButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                          color: Theme.of(context).accentColor,
                                          child: Text("invite_invite".tr()),
                                          onPressed: () {
                                            showPicDialog();
                                          },
                                        ),
                                      ),*/
                                      Container(
                                        width: ScreenUtil().setWidth(288+288),
                                        height: ScreenUtil().setHeight(68),
                                        child: RaisedButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                          color: Theme.of(context).accentColor,
                                          child: Text("invite_make".tr()),
                                          onPressed: () {
                                            showPicDialog();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                child: Card(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
                  ),
                  elevation: 4.0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colours.dark_bg_gray_,
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
                    ),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.only(left:ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                            height: ScreenUtil().setHeight(100),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('invite_lr'.tr()+":",style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: ScreenUtil().setSp(28))),
                                    Text('0 USDT',style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w500,fontFamily: 'Din')),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('invite_see'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                                    Icon(Icons.keyboard_arrow_right,color: Color(0xFF9298A8),)
                                  ],
                                )
                              ],
                            ),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            CommonUtil.showToast('invite_no'.tr());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(72),left: ScreenUtil().setWidth(32),right:ScreenUtil().setWidth(32),bottom: ScreenUtil().setHeight(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('invite_record'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32)),),
                    Text('invite_member_count'.tr()+inviteCount,style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24)),),
                  ],
                )
              ),
              Divider(),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(80),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('create_time'.tr(),style: tvTitlesub,),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('invite_user'.tr(),style: tvTitlesub,),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("invite_auth_status".tr(),style: tvTitlesub,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _getItem(index);
                },
              ),
            ],
          ),
        )
      ),
    );


  }

}
