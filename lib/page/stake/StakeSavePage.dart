
import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_detail_entity.dart';
import 'package:hibi/model/pyramid_product_entity.dart';
import 'package:hibi/page/activity/PyramidRulePage.dart';
import 'package:hibi/page/money/ChangePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/PyramidItem.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class StakeSavePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<StakeSavePage> {


  num count = 1;
  int curretIndex = 0;

  String useMoney = '0';

  String rule = '';
  String yieldRule = '';

  StreamSubscription  _sub;

  @override
  void initState() {
    super.initState();
    _sub = eventBus.on<RefreshAsstes>().listen((event) {
      _getAssetsDetail();
    });
    _getAssetsDetail();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void getRules(){
    DioManager.getInstance().post(Url.PYRAMID_PRODUCT_RULE, null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      setState(() {
        rule = dataMap['data']['rule'];
        yieldRule = dataMap['data']['yieldRule'];
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  Future _getAssetsDetail() async{
    var params = {'symbol':"BBT"};
    DioManager.getInstance().post(Url.ASSETS_DETAIL, params, (data2){
      AssetsDetailEntity assetsDetailEntity = JsonConvert.fromJsonAsT(data2);
      setState(() {
        for(AssetsDetailDataCoinParticularsList item in assetsDetailEntity.data.coinParticularsList){
          if(item.accountTypeEnum == 'FINANCE'){
            useMoney = item.availableBalance.toString();
          }
        }
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }


  void saved(){
    _progressDialog.show();

  }

  void savedSuccess(){
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B2438),
          content:Text('存入双星计划成功，从明天开始计算收益，账户详情可查看持仓及收益'),
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


  TextStyle tvTitle = TextStyle(color:Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din');
  TextStyle tvValue = TextStyle(color:Colours.dark_text_gray,fontSize: ScreenUtil().setSp(29),fontFamily: 'Din',fontWeight: FontWeight.bold);

  Widget _buildProItem(String title,String value){
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(92),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title,style: tvTitle,),
              Text(value,style: tvValue,)
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  final TextEditingController _bbt = new TextEditingController();

  Widget _buildCount(){
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(92),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                child: Text('锁仓数量',style: tvTitle,),
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              ),
              Expanded(
                child: TextField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp(r"[\d.]"))
                  ],
                  onChanged: (e){

                  },
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _bbt,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      fontFamily: 'Din'
                  ),
                  decoration:InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: '请输入锁仓数量',
                      contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                      suffixIcon: Container(
                        width: ScreenUtil().setWidth(150),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("BBT",style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Color(0xffe0e0e7)),),
                            Container(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                            ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Text('全部',style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Colours.dark_accent_color),),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }


  Widget _buildRules(){
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff202d49),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20),horizontal: ScreenUtil().setWidth(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('规则说明',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(29),fontWeight: FontWeight.bold),),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child:Text(rule,style: TextStyle(color:Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),)
          )
        ],
      )
    );
  }

  String getTimeStr(){
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(Duration(days: 1));
    return CommonUtil.pad(tomorrow.year.toString())+"-"+CommonUtil.pad(tomorrow.month.toString())+"-"+CommonUtil.pad(tomorrow.day.toString());
  }

  ProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
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
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        title: Text('节点挖矿'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(32),horizontal: ScreenUtil().setWidth(32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildProItem('最小可投数量','1',),
                _buildProItem('最大可投数量','1',),
                _buildProItem('挖矿周期','1',),
                _buildProItem('日产能','1',),
                _buildProItem('生效时间','1',),
                _buildCount(),
                Padding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('理财账户可用：'+useMoney+' BBT',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(20),fontFamily: 'Din'),),
                      GestureDetector(
                        child:Text('  立即划转',style: TextStyle(color: Color(0xFF1A72CE),fontSize: ScreenUtil().setSp(20),),),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ChangePage();
                          })).then((value) => (){
                            _getAssetsDetail();
                          });
                        },
                      )
                    ],
                  ),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                ),
                Padding(
                  child: SizedBox(
                    width: ScreenUtil().setWidth(686),
                    height: ScreenUtil().setHeight(88),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.all(0.0),
                      child: Text('确认购买',style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        saved();
                      },
                      elevation: 4.0,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(80),bottom: ScreenUtil().setHeight(60)),
                ),
                _buildRules()
              ],
            ),
          )
      ),
    );
  }

}
