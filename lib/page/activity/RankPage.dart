import 'dart:convert';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class RankPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<RankPage> {

  bool isJy = true;
  bool isBTC = true;

  String detailText = '';
  String detailImg = '';

  List<dynamic> listBTC = [];
  List<dynamic> listETH = [];
  List<dynamic> listVolume = [];

  bool isSign = false;
  @override
  void initState() {
    super.initState();
    getActivityList();
    getActivityDetail();
    checkSingUp();
  }

  void SignUp(){
    if(!isSign){
      _progressDialog.show();
      DioManager.getInstance().post("/rank/deal/signUp", null, (data){
        _progressDialog.hide();
        checkSingUp();
      }, (error){
        _progressDialog.hide();
        CommonUtil.showToast(error);
      });
    }
  }

  void checkSingUp(){
    DioManager.getInstance().post("/rank/deal/eligibility", null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      setState(() {
        isSign = dataMap['data'];
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  void getActivityList(){
    DioManager.getInstance().post("/rank/deal/activity/coin", null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      setState(() {
        listBTC = dataMap['data']['rangeBTC'];
        listETH = dataMap['data']['rangeETH'];
        listVolume = dataMap['data']['rangeYIELD'];
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  void getActivityDetail(){
    DioManager.getInstance().post("/rank/deal/details", null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      setState(() {
        detailText = dataMap['data']['details'];
        detailImg = dataMap['data']['img'];
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }


  Widget _buildTop(){
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(400),
      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFf33EDB5),
              Color(0xFF1740D7)
            ]
        ),
      ),
      child: Container(
          width: double.infinity,
          child: Column(
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
              Expanded(
                  child: Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('交易大赛排行榜',style: TextStyle(color:Colors.white,fontSize: ScreenUtil().setSp(36),fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(20)),
                              child:Text('2020年8月25日-2020年9月15日',style: TextStyle(color:Colors.white.withOpacity(0.6),fontSize: ScreenUtil().setSp(20),fontFamily: 'Din' ),),
                            ),
                            GestureDetector(
                              onTap: (){
                                  SignUp();
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(156),
                                height: ScreenUtil().setHeight(48),
                                decoration: BoxDecoration(
                                    color: isSign?Colors.grey:Colours.dark_accent_color,
                                    borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))
                                ),
                                child: Center(
                                  child: Text(isSign?'已报名':'立即报名',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),),
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                            )
                          ],
                        ),
                        Image.asset('res/activity_bg.png',width: ScreenUtil().setWidth(300),height: ScreenUtil().setWidth(300),)
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
  
  Widget _buildTab(){
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(78),
      color: Color(0xFF00468E),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('交易量榜'),
                  isJy?Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(1)),
                    width: ScreenUtil().setWidth(56),
                    height: ScreenUtil().setHeight(4),
                    color: Colors.white,
                  ):Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(1)),
                    width: ScreenUtil().setWidth(56),
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
                  Text('收益率榜'),
                  !isJy?Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(1)),
                    width: ScreenUtil().setWidth(56),
                    height: ScreenUtil().setHeight(4),
                    color: Colors.white,
                  ):Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(1)),
                    width: ScreenUtil().setWidth(56),
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

  Widget _buildTab2(){
    if(!isJy){
      return Container();
    }
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(88),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: ScreenUtil().setWidth(150),
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('BTC榜',style: TextStyle(color: isBTC?Colours.dark_accent_color:Colors.white.withOpacity(0.23)),),
                  isBTC?Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(90),
                    height: ScreenUtil().setHeight(4),
                    color: Colours.dark_accent_color,
                  ):Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(90),
                    height: ScreenUtil().setHeight(4),
                  )
                ],
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              setState(() {
                isBTC = true;
              });
            },
          ),
          GestureDetector(
            child: Container(
              width: ScreenUtil().setWidth(150),
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('ETH榜',style: TextStyle(color: !isBTC?Colours.dark_accent_color:Colors.white.withOpacity(0.23)),),
                  !isBTC?Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(90),
                    height: ScreenUtil().setHeight(4),
                    color: Colours.dark_accent_color,
                  ):Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(90),
                    height: ScreenUtil().setHeight(4),
                  )
                ],
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              setState(() {
                isBTC = false;
              });
            },
          )
        ],
      )
    );
  }

  Widget _buildStatus(){
    TextStyle tvTitle = TextStyle(color: Colors.white.withOpacity(0.23),fontSize: ScreenUtil().setSp(24));
    return Column(
      children: <Widget>[
        Divider(),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(68),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: Row(
            children: <Widget>[
              Expanded(
                flex:1,
                child: Text('排名',style: tvTitle,),
              ),
              Expanded(
                flex:2,
                child: Text('用户ID',style: tvTitle,),
              ),
              Expanded(
                  flex:3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(isJy?'交易量':'收益率',style: tvTitle,),
                    ],
                  )

              ),
            ],
          ),
        )
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

  Widget _buildList(){
    TextStyle tvTitle = TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din');
    TextStyle tvValue = TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din');

    List<Widget> views = [];
    if(isJy){
      if(isBTC){
        for(int i =0;i<listBTC.length;i++){
          views.add(Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(68),
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:1,
                  child: _renderIcon(i+1),
                ),
                Expanded(
                  flex:2,
                  child: Text(listBTC[i]['userName'].toString(),style: tvTitle,),
                ),
                Expanded(
                    flex:3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(listBTC[i]['tradedAmount'].toString(),style: tvValue,),
                      ],
                    )
                ),
              ],
            ),
          ));
        }
      }else{
        for(int i =0;i<listETH.length;i++){
          views.add(Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(68),
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:1,
                  child: _renderIcon(i+1),
                ),
                Expanded(
                  flex:2,
                  child: Text(listETH[i]['userName'].toString(),style: tvTitle,),
                ),
                Expanded(
                    flex:3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(listETH[i]['tradedAmount'].toString(),style: tvValue,),
                      ],
                    )
                ),
              ],
            ),
          ));
        }
      }
    }else{
      for(int i =0;i<listVolume.length;i++){
        views.add(Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(68),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: Row(
            children: <Widget>[
              Expanded(
                flex:1,
                child: _renderIcon(i+1),
              ),
              Expanded(
                flex:2,
                child: Text(listVolume[i]['userName'].toString(),style: tvTitle,),
              ),
              Expanded(
                  flex:3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(listVolume[i]['yieldPer'].toString(),style: tvValue,),
                    ],
                  )
              ),
            ],
          ),
        ));
      }
    }

    return Column(
      children: views,
    );
  }

  Widget _buildDetail(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
          child: CachedNetworkImage(
            imageUrl: detailImg,
            width: double.infinity,
            height: ScreenUtil().setHeight(670),
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(20)),
          child: Text('活动规则',style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(32)),),
        ),
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(40)),
          child: Text(detailText,style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(28)),),
        ),
      ],
    );
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
    return new Material(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colours.dark_bg_gray),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTop(),
                _buildTab(),
                _buildTab2(),
                _buildStatus(),
                _buildList(),
                _buildDetail(),
              ],
            ),
          ),
        )
    );
  }
}
