import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_detail_entity.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<ChangePage> {

  String code = 'BBT';
  final TextEditingController _count = new TextEditingController();
  final TextEditingController _codes = new TextEditingController();

  AssetsDetailData data ;

  String fromType = 'BIBI';
  String toType = 'CALCULA';

  dynamic configType = [
    {'from':'BIBI','to':'CALCULA,FINANCE'},
    {'from':'CALCULA','to':'BIBI,FINANCE'},
    {'from':'PURCHASE','to':'BIBI,FINANCE'},
    {'from':'FINANCE','to':'BIBI,CALCULA'},
  ];


  @override
  void initState() {
    super.initState();
    setState(() {
      _codes.text = code;
    });
    _getAssetsDetail();
  }

  Future _getAssetsDetail() async{
    var params = {'symbol':code};
    DioManager.getInstance().post(Url.ASSETS_DETAIL, params, (data2){
      AssetsDetailEntity assetsDetailEntity = JsonConvert.fromJsonAsT(data2);
      setState(() {
        data = assetsDetailEntity.data;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  showSelect(){
    List<Widget> list = [];
    list.add(SimpleDialogOption(
      child: new Text(getStrType('BIBI')),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          fromType = 'BIBI';
          toType = 'CALCULA';
        });
      },
    ));
    list.add(SimpleDialogOption(
      child: new Text(getStrType('CALCULA')),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          fromType = 'CALCULA';
          toType = 'BIBI';
        });
      },
    ));
    list.add(SimpleDialogOption(
      child: new Text(getStrType('PURCHASE')),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          fromType = 'PURCHASE';
          toType = 'BIBI';
        });
      },
    ));
    list.add(SimpleDialogOption(
      child: new Text(getStrType('FINANCE')),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          fromType = 'FINANCE';
          toType = 'BIBI';
        });
      },
    ));
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor: Color(0xFF1B2438),
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }

  showSelect2(){
    List<Widget> list = [];
    for(dynamic item in configType){
      if(fromType == item['from']){
        String tos = item['to'];
        List<String> lists = tos.split(',');
        for(String text in lists){
          list.add(SimpleDialogOption(
            child: new Text(getStrType(text)),
            onPressed: () {
              setState(() {
                toType = text;
              });
              Navigator.of(context).pop();
            },
          ));
        }
      }
    }
    /*if(fromType != 'BIBI'){
      list.add(SimpleDialogOption(
        child: new Text(getStrType('BIBI')),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ));
    }else{
      list.add(SimpleDialogOption(
        child: new Text(getStrType('CALCULA')),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            fromType = 'BIBI';
            toType = 'CALCULA';
          });
        },
      ));
    }*/
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor: Color(0xFF1B2438),
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }

  showSelect3(){
    List<Widget> list = [];
    list.add(SimpleDialogOption(
      child: new Text('BBT'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));

    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor: Color(0xFF1B2438),
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }

  String getStrType(String curretType){
    switch(curretType){
      case 'BIBI':
        return 'assets_bbzh'.tr();
        break;
      case 'PURCHASE':
        return 'assets_sgzh'.tr();
        break;
      case 'CALCULA':
        return 'assets_slzh'.tr();
        break;
      case 'FINANCE':
        return 'assets_lczh'.tr();
        break;
    }
  }


  String _renderUsable(){
    if(data == null){
      return '0';
    }
    for(int i=0;i<data.coinParticularsList.length;i++){
      if(data.coinParticularsList[i].accountTypeEnum == fromType){
        return data.coinParticularsList[i].availableBalance.toString();
      }
    }
  }

  _submit(){
    _progressDialog.show();
    var params={'amount':_count.text,'fromWalletType':fromType,'toWalletType':toType,'unit':code};
    DioManager.getInstance().post(Url.MONEY_CHANGE, params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      eventBus.fire(new RefreshAsstes());
      Navigator.pop(context,"refresh");
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  ProgressDialog _progressDialog;
  @override
  Widget build(BuildContext context) {
    TextStyle tvTitle = TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24));
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
        title: Text('assets_hz'.tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(230),
              child: Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(80),
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('from'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(28)),),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(14),bottom: ScreenUtil().setHeight(14)),
                          child:Image.asset('res/diver_line.png',width: ScreenUtil().setWidth(4),height: ScreenUtil().setHeight(34),),
                        ),
                        Text('to'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(28)),)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getStrType(fromType),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32))),
                              ],
                            ),
                            onTap: (){
                              showSelect();
                            },
                            behavior: HitTestBehavior.opaque,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(28),bottom: ScreenUtil().setHeight(28)),
                            child:Divider(color: Colours.dark_text_gray.withOpacity(0.05),height: ScreenUtil().setHeight(2),),
                          ),
                          GestureDetector(
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getStrType(toType),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32))),
                              ],
                            ),
                            onTap: (){
                              showSelect2();
                            },
                            behavior: HitTestBehavior.opaque,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(10),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              'coin_type'.tr(),
                              style:tvTitle
                          ),
                        ],
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      showSelect3();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: TextField(
                      enabled: false,
                      controller: _codes,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                          fontFamily: 'Din'
                      ),
                      decoration:InputDecoration(
                          hintText: code,
                          contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                          suffixIcon: Container(
                            width: ScreenUtil().setWidth(200),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text('deposit_select'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(24),color: Colours.dark_text_gray.withOpacity(0.3),)),
                                Icon(Icons.keyboard_arrow_right,color: Colours.dark_text_gray.withOpacity(0.3),)
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              'count'.tr(),
                              style:tvTitle
                          ),
                        ],
                      )
                  ),
                  TextField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp(r"[\d.]"))
                    ],
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
                                    _count.text = _renderUsable();
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
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(80),left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
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
      ),
    );
  }
}
