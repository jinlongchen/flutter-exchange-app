import 'dart:convert';
import 'dart:io';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/activity_histroy_entity.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../WebPage.dart';

class ActivityHistoryPage extends StatefulWidget {

  const ActivityHistoryPage({Key key}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<ActivityHistoryPage> {
  List<ActivityHistroyDataData> historyList = [];
  ScrollController _controller = new ScrollController();
  int _page = 1;
  bool hasMore = true;
  bool isLoad = false;

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
    initData();
  }

  void initData(){
    setState(() {
      _page = 1;
      historyList = [];
      hasMore = true;
      isLoad = false;
    });
    var params = {'symbol':"BBT",'pageNo':1,'pageSize':20,};
    DioManager.getInstance().post(Url.ACTIVITY_HISTROY, params, (data){
      ActivityHistroyEntity activityHistroyEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        historyList =  activityHistroyEntity.data.data;
        if(activityHistroyEntity.data.total <= 1 * 20){
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
    var params = {'symbol':"BBT",'pageNo':_page,'pageSize':20,};
    DioManager.getInstance().post(Url.ACTIVITY_HISTROY, params, (data) async {
      ActivityHistroyEntity orderListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        historyList.addAll(orderListEntity.data.data);
        if(orderListEntity.data.total <= _page * 20){
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

  TextStyle tvValue = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvTitle = TextStyle(color: Colours.dark_textTitle,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din',fontWeight: FontWeight.w500);

  Widget getItem(int index){
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(188),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(84),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("BBT",style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28)),)
                      ],
                    ),
                    Text(historyList[index].runStatus == 1?"yff".tr():"wff".tr(),style: TextStyle(color: Color(0xFF9496A2),fontSize: ScreenUtil().setSp(24)),)
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(100),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('ffsl'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].sendAmount.toString(),style: tvTitle,),
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex:2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('create_time'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].createTime.toString(),style: tvTitle,),
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Colours.dark_text_gray.withOpacity(0.05),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: Scaffold(
          backgroundColor: Colours.dark_bg_gray,
          appBar: AppBar(
            leading: AppBarReturn(),
            centerTitle: false,
            title: Text('xd_ffjl'.tr()),
          ),
          body: ListView.builder(
            controller: _controller,
            itemCount: historyList.length,
            itemBuilder: (BuildContext context, int index) {
              return getItem(index);
            },
          ),
        )
    );
  }

}
