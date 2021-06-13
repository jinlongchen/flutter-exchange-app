
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class PyramidSavePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<PyramidSavePage> {

  List<PyramidProductData> _list = [];

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
    getProductList();
    getRules();
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

  void getProductList() {
    DioManager.getInstance().post(Url.PYRAMID_PRODUCT_LIST, null, (data){
      PyramidProductEntity productEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        _list = productEntity.data;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  void saved(){
    _progressDialog.show();
    var params = {"productName":_list[curretIndex].level,'number':count.toString()};
    DioManager.getInstance().post(Url.PYRAMID_PRODUCT_BUY, params, (data){
      _progressDialog.hide();
      eventBus.fire(new RefreshPyramidSave());
      getProductList();
      _getAssetsDetail();
      savedSuccess();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
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

  Widget _buildItems(){
    List<Widget> vies = [];
    for(int i=0;i<_list.length;i++){
      vies.add(
        GestureDetector(
          child: PyramidItem(title: _list[i].level,value: _list[i].mealNum.toString(),isSelected: curretIndex == i?true:false,isActived: _list[i].status == 0?true:false,),
          onTap: (){
            if(_list[i].status == 1){
              return;
            }
            setState(() {
              curretIndex = i;
              count = 1;
            });
          },
        )
      );
    }
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
      child: Wrap(
        spacing: ScreenUtil().setWidth(22),
        children: vies
      ),
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

  Widget _buildPriceItem(){
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(92),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('价格',style: tvTitle,),
              Text((_list[curretIndex].mealNum*count).toString()+' BBT',style: TextStyle(color:Colours.dark_accent_color,fontSize: ScreenUtil().setSp(29),fontFamily: 'Din',fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  void addCount(int type){
    if(type == 0){
      if(count == 1){
        return;
      }
      setState(() {
        count = count -1;
      });
    }else{
      if(count == _list[curretIndex].maxNum){
        return;
      }
      setState(() {
        count = count +1;
      });
    }
  }

  Widget _buildCountItem(){
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(92),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('数量',style: tvTitle,),
              Container(
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setHeight(58),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.2),width: 1)
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex:2,
                        child: GestureDetector(
                          child: Center(
                              child: Icon(Icons.remove,color: Colours.dark_text_gray.withOpacity(0.8),)
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            addCount(0);
                          },
                        )
                    ),
                    Expanded(
                        flex:3,
                        child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                      color: Colors.white.withOpacity(0.2),width: 1
                                  ),
                                  right: BorderSide(
                                      color: Colors.white.withOpacity(0.2),width: 1
                                  ),
                                )
                            ),
                            child: Center(
                              child: Text(count.toString()),
                            )
                        )
                    ),
                    Expanded(
                        flex:2,
                        child:GestureDetector(
                          child: Center(
                              child: Icon(Icons.add,color: Colours.dark_text_gray.withOpacity(0.8),)
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            addCount(1);
                          },
                        )
                    ),
                  ],
                ),
              )
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
        title: Text('pyramid_save'.tr()),
        centerTitle: false,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PyramidRulePage(text: yieldRule,);
                  }));
                },
                child: Center(
                    child: Row(
                      children: <Widget>[
                        Text('pyramid_rule'.tr(),style: TextStyle(
                            color: Colours.dark_text_gray.withOpacity(0.6)
                        ),),
                      ],
                    )
                ),
              )
          )
        ],
      ),
      body: _list.length == 0?Container():SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(32),horizontal: ScreenUtil().setWidth(32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('选择存入额度',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),),
                _buildItems(),
                _buildProItem('日收益率',(_list[curretIndex].xYield*100).toStringAsFixed(2)+'%'),
                _buildProItem('双星计划周期',_list[curretIndex].period.toString()+'天'),
                _buildProItem('生效时间',getTimeStr()),
                _buildProItem('限购',_list[curretIndex].maxNum.toString()+'个'),
                _buildCountItem(),
                _buildPriceItem(),
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
                      child: Text('确认存入',style: TextStyle(color: Colors.white),),
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
