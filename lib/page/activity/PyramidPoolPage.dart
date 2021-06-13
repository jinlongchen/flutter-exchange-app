import 'dart:async';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/pyramid_pool_entity.dart';
import 'package:hibi/page/mine/InvitePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/EmptyView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';

import 'PyramidReciprocalPage.dart';
import 'PyramidSavePage.dart';

class PyramidPoolPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<PyramidPoolPage> {

  PyramidPoolData _data;

  final List<dynamic> listDefalut = [
    {"title":"最后一名","value":"独享40%"},
    {"title":"倒数第二名","value":"独享10%"},
    {"title":"倒数第三名","value":"独享5%"},
    {"title":"倒数4-10名","value":"每人独享2%"},
    {"title":"倒数11-100名","value":"均分31%"},
  ];

   List<dynamic> spillCloseDTOList = [];
   List<dynamic> prizeAllocationProportionDTO = [];
   String prizePoolSum = '';
   String prizePoolAdd = '';
   int countDown = 0;

  StreamSubscription  _sub;


  @override
  void initState() {
    super.initState();
    getData();
    _sub = eventBus.on<RefreshPyramidSave>().listen((event) {
      getData();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
  
  void getData(){
    DioManager.getInstance().post(Url.PYRAMID_POOL, null, (data){
      PyramidPoolEntity poolEntity = JsonConvert.fromJsonAsT(data);
      for(PyramidPoolDataSpillCloseDTOList item in poolEntity.data.spillCloseDTOList){
        spillCloseDTOList.add({"title":item.userName,"value":item.closeNum.toString()});
      }
      setState(() {
        prizeAllocationProportionDTO = [
          {"title":"最后一名","value":poolEntity.data.prizeAllocationProportionDTO.prizeAllocationProportionFirst},
          {"title":"倒数第二名","value":poolEntity.data.prizeAllocationProportionDTO.prizeAllocationProportionTwo},
          {"title":"倒数第三名","value":poolEntity.data.prizeAllocationProportionDTO.prizeAllocationProportionThree},
          {"title":"倒数4-10名","value":poolEntity.data.prizeAllocationProportionDTO.prizeAllocationProportionFour},
          {"title":"倒数11-100名","value":poolEntity.data.prizeAllocationProportionDTO.prizeAllocationProportionFive},
        ];
        prizePoolSum = poolEntity.data.prizePoolSum.toString();
        prizePoolAdd = poolEntity.data.prizePoolAdd.toString();
        countDown = poolEntity.data.countDown;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  Widget _buildTop(){
    TextStyle tvTitle = TextStyle(color: Colors.white.withOpacity(0.8),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din');
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(532),
      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF1740D7),
              Color(0xFf1ECCC2)
            ]
        ),
      ),
      child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
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
                  Text('算力分红',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(40)),)
                ],
              ),
              Container(
                height: ScreenUtil().setHeight(20),
              ),
              Expanded(
                  child: Padding(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('当前双星池总量',style: tvTitle,),
                                  Padding(
                                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                                      child:Text(prizePoolSum+' BBT',style: TextStyle(color: Color(0xffffd086),fontSize: ScreenUtil().setSp(44),fontFamily: 'Din'))
                                  )
                                ],
                              ),
                              GestureDetector(
                                child:Image.asset('res/pyramid_buy.png',width: ScreenUtil().setWidth(300),height: ScreenUtil().setHeight(56),),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return PyramidSavePage();
                                  }));
                                },
                              )
                            ],
                          )
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('昨日新增',style: tvTitle),
                                  Padding(
                                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                                    child:Row(
                                      children: <Widget>[
                                        Text('+ '+prizePoolAdd+' BBT',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din'),),
                                        Padding(
                                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                          child:Image.asset('res/pyramid_arrow_up.png',width: ScreenUtil().setWidth(20),height: ScreenUtil().setHeight(30),)
                                        )
                                      ],
                                    )
                                  )
                                ],
                              ),
                              Padding(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text('分红倒计时',style: tvTitle),
                                    Padding(
                                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                                        child:  CountdownTimer(endTime: countDown,textStyle: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din'),),
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                              )
                            ],
                          )
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(10),bottom: ScreenUtil().setHeight(20)),
                  )
              ),
            ],
          )
      ),
    );
  }

  bool isJy = true;

  Widget _buildTab(){
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(150),
      child: Row(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('特别奖',style: TextStyle(color: isJy?Colours.dark_accent_color:Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(32)),),
                    isJy?Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                      width: ScreenUtil().setWidth(96),
                      height: ScreenUtil().setHeight(4),
                      color: Colours.dark_accent_color,
                    ):Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                      width: ScreenUtil().setWidth(96),
                      height: ScreenUtil().setHeight(4),
                    )
                  ],
                ),
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  setState(() {
                    isJy = true;
                  });
                },
              )
          ),
          Expanded(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('直推奖',style: TextStyle(color: !isJy?Colours.dark_accent_color:Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(32))),
                  !isJy?Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                    width: ScreenUtil().setWidth(96),
                    height: ScreenUtil().setHeight(4),
                    color: Colours.dark_accent_color,
                  ):Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                    width: ScreenUtil().setWidth(96),
                    height: ScreenUtil().setHeight(4),
                  )
                ],
              ),
              behavior: HitTestBehavior.opaque,
              onTap: (){
                setState(() {
                  isJy = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }


  TextStyle tvTitle = TextStyle(color: Colors.white.withOpacity(0.23),fontSize: ScreenUtil().setSp(24));


  Widget _buildOne(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('算力池超过100万后，超出部分每天结算时按照如下比例，加权分配给当日直邀好友累计存入量前十名',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28)),),
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(52),bottom: ScreenUtil().setHeight(34)),
          child:Text('昨日直邀好友累计存入量排名',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32)))
        ),
        Divider(),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(100),
          child: Row(
            children: <Widget>[
              Expanded(
                flex:1,
                child: Text('排名',style: tvTitle,),
              ),
              Expanded(
                flex: 3,
                child: Text('用户ID',style: tvTitle,),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text('分红额度(BBT)',style: tvTitle,),
                )
              )
            ],
          ),
        ),
        spillCloseDTOList.length == 0?EmptyView():ListView.builder(
          padding: EdgeInsets.only(top: 0),
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: spillCloseDTOList.length, //数据的数量
          itemBuilder: (BuildContext context,int index){
            return  _renderItem(spillCloseDTOList[index],index);
          },
        ),
      ],
    );
  }

  Widget _buildTwo(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(52),bottom: ScreenUtil().setHeight(34)),
            child:Text('若72小时无人存入，按以下规则分配：',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32)))
        ),
        Divider(),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(100),
          child: Row(
            children: <Widget>[
              Expanded(
                flex:1,
                child: Text('',style: tvTitle,),
              ),
              Expanded(
                flex: 3,
                child: Text('排名情况',style: tvTitle,),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('分红分配',style: tvTitle,),
                  )
              )
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.only(top: 0),
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: prizeAllocationProportionDTO.length, //数据的数量
          itemBuilder: (BuildContext context,int index){
            return  _renderItem(prizeAllocationProportionDTO[index],index);
          },
        ),
        GestureDetector(
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('最后存入排名详情',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                Row(
                  children: <Widget>[
                    Text('点击查看',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                    Icon(Icons.arrow_forward_ios,size: 12,color: Colours.dark_text_gray.withOpacity(0.6),)
                  ],
                )
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PyramidReciprocalPage();
            }));
          },
          behavior: HitTestBehavior.opaque,
        ),
        Divider()
      ],
    );
  }

  Widget _renderIcon(int index){
    if(index <=3){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(index == 1?'res/activity_no1.png':index == 2?'res/activity_no2.png':'res/activity_no3.png',width: ScreenUtil().setWidth(44),height: ScreenUtil().setWidth(44),)
        ],
      );
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
              child:Text(index.toString(),style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),)
          )
        ],
      );
    }
  }

  Widget _renderItem(dynamic item,int index){
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(100),
          child: Row(
            children: <Widget>[
              Expanded(
                flex:1,
                child: _renderIcon(index+1),
              ),
              Expanded(
                flex: 3,
                child: Text(item['title'],style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(item['value'],style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),),
                  )
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Material(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colours.dark_bg_gray),
          child: Stack(
            children: <Widget>[
              _buildTop(),
              Positioned(
                top: ScreenUtil().setHeight(500),
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTab(),
                        !isJy?_buildOne():_buildTwo()
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colours.dark_bg_gray,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(ScreenUtil().setWidth(40)),topRight: Radius.circular(ScreenUtil().setWidth(40)))
                    ),
                  ),
                )
              )
            ],
          )
        )
    );
  }
}
