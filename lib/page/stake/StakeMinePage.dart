import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/pyramid_mine_entity.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';


class StakeMinePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<StakeMinePage> {
  List<PyramidMineDataData> _list = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData(){
    var params = {'pageNum':'1','pageSize':'999'};
    DioManager.getInstance().post(Url.PYRAMID_PRODUCT_MINE, params, (data){
      PyramidMineEntity pyramidMineEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        _list = pyramidMineEntity.data.data;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  void renewal(int orderId){
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B2438),
          title: Text('label_tip'.tr()),
          content:Text('确定要复投吗？'),
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
                Navigator.of(context).pop();
                renewalReal(orderId);
              },
            ),
          ],
        );
      },
    );
  }

  void renewalReal(int orderId){
    _progressDialog.show();
    var params = {'orderId':orderId,'format':"1"};
    DioManager.getInstance().post('/pobb/pyramid/renewal/product', params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      getData();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  void redeem(int orderId){
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B2438),
          title: Text('label_tip'.tr()),
          content:Text('确定要赎回吗？'),
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
                Navigator.of(context).pop();
                redeemReal(orderId);
              },
            ),
          ],
        );
      },
    );
  }

  void redeemReal(int orderId){
    _progressDialog.show();
    var params = {'orderId':orderId,'format':"1"};
    DioManager.getInstance().post('/pobb/pyramid/redeem/product', params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      getData();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  TextStyle tvTitlesub = TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(20));
  TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din');

  Widget _renderItem(PyramidMineDataData item){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(38)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(38)),
      width: ScreenUtil().setWidth(686),
      decoration: BoxDecoration(
        color: Colours.dark_bg_gray_,
        borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32)),
            width: double.infinity,
            height: ScreenUtil().setHeight(108),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(item.projectId,style: TextStyle(color: Colours.dark_accent_color,fontFamily: 'Din',fontSize: ScreenUtil().setSp(32),fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Divider(),
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(142),
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32)),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(item.status == 0?'进行中':'已到期',style: tvTitle,),
                      Text('状态',style: tvTitlesub,),
                    ],
                  ),
                ),
                Expanded(
                  flex:5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(item.buyNum.toString(),style: tvTitle,),
                      Text("数量(个)",style: tvTitlesub,),
                    ],
                  ),
                ),
                Expanded(
                  flex:5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(item.days.toString(),style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din'),),
                      Text("剩余锁定周期(天)",style: tvTitlesub,),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(622),
            height: ScreenUtil().setHeight(68),
            decoration: BoxDecoration(
                color: Color(0xFF2C3B5C),
                borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'POCS算力周增长为',
                      style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),
                  ),
                  TextSpan(
                      text: (item.pocsIncrease*100).toStringAsFixed(2)+"%",
                      style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din')
                  ),
                  TextSpan(
                    text: '，当前日收益率为',
                    style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),
                  ),
                  TextSpan(
                      text: (item.productYield*100).toStringAsFixed(2)+"%",
                      style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din')
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(32),left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    if(item.status != 0){
                      redeem(item.orderId);
                    }
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(296),
                    height: ScreenUtil().setHeight(60),
                    decoration: BoxDecoration(
                        color: item.status ==0?Color(0xff343D51):Color(0xff1E76DD),
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))
                    ),
                    child: Center(
                      child: Text(item.status == 0?'赎回':'赎回',style: item.status==0?TextStyle(color: Colors.white.withOpacity(0.3),fontSize: ScreenUtil().setSp(24)):TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),),
                    ),
                  ),
                  behavior: HitTestBehavior.opaque,
                ),
                GestureDetector(
                  onTap: (){
                    renewal(item.orderId);
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(296),
                    height: ScreenUtil().setHeight(60),
                    decoration: BoxDecoration(
                        color: Colours.dark_accent_color,
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))
                    ),
                    child: Center(
                      child: Text('复投',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),),
                    ),
                  ),
                  behavior: HitTestBehavior.opaque,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> renderProducts(){
    List<Widget> views = [];
    for(PyramidMineDataData item in _list){
      views.add(_renderItem(item));
    }
    return views;
  }

  ProgressDialog _progressDialog;
  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        title: Text('我的矿机'),
        centerTitle: false,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: GestureDetector(
                onTap: (){

                },
                child: Center(
                    child: Row(
                      children: <Widget>[
                        Text('到期记录',style: TextStyle(
                            color: Colours.dark_text_gray.withOpacity(0.6)
                        ),),
                      ],
                    )
                ),
              )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: renderProducts()
        ),
      )
    );
  }
}
