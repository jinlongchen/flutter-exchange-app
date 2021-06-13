import 'dart:async';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_detail_entity.dart';
import 'package:hibi/model/pocs_info_entity.dart';
import 'package:hibi/model/pyramid_home_entity.dart';
import 'package:hibi/page/activity/PyramidInvitePage.dart';
import 'package:hibi/page/activity/PyramidMinePage.dart';
import 'package:hibi/page/contract/PocsCodePage.dart';
import 'package:hibi/page/contract/PocsListPage.dart';
import 'package:hibi/page/mine/InvitePage.dart';
import 'package:hibi/page/money/ChangePage.dart';
import 'package:hibi/page/stake/StakeMinePage.dart';
import 'package:hibi/page/stake/StakeSavePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/SmallFlatButton.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';




class StakePage extends StatefulWidget {

  const StakePage({Key key}) : super(key: key);
  @override
  _State createState() => new _State();
}

class _State extends State<StakePage> {
  PyramidHomeData pyramidHomeData;

  AssetsDetailData data ;
  StreamSubscription  _sub;
  StreamSubscription  _sub2;


  num maxData = 0;
  num curretData = 0;
  @override
  void initState() {
    super.initState();
    setState(() {

    });
    _sub = eventBus.on<RefreshAsstes>().listen((event) {
      _getAssetsDetail();
    });
    _sub2 = eventBus.on<RefreshPyramidSave>().listen((event) {
      _getData();
    });
    _getAssetsDetail();
    _getData();
  }

  void _getData(){
    DioManager.getInstance().post(Url.PYRAMID_HOME, null, (data){
      PyramidHomeEntity pyramidHomeEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        pyramidHomeData = pyramidHomeEntity.data;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _sub2.cancel();
    super.dispose();
  }

  Future _getAssetsDetail() async{
    var params = {'symbol':"BBT"};
    DioManager.getInstance().post(Url.ASSETS_DETAIL, params, (data2){
      AssetsDetailEntity assetsDetailEntity = JsonConvert.fromJsonAsT(data2);
      setState(() {
        data = assetsDetailEntity.data;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }


  Widget _renderCardAccount(int index){
    LinearGradient colorbg = LinearGradient(colors: [Color(0xFF202D49), Color(0xFF202D49)]);
    String title = "";
    switch(data.coinParticularsList[index].accountTypeEnum){
      case "BIBI":
        title = 'assets_bbzh'.tr();
        //colorbg = LinearGradient(colors: [Color(0xFFFF975D), Color(0xFFFFBA76)]);
        break;
      case "PURCHASE":
        title = 'assets_sgzh'.tr();
        //colorbg = LinearGradient(colors: [Color(0xFF00ABB8), Color(0xFF00DDB3)]);
        break;
      case "CALCULA":
        title = 'assets_slzh'.tr();
        //colorbg = LinearGradient(colors: [Color(0xFF097AFF), Color(0xFF48B2F1)]);
        break;
      case "ACTIVITY":
        title = 'assets_xdzh'.tr();
        //colorbg = LinearGradient(colors: [Color(0xFF392CDD), Color(0xFF5E48F1)]);
        break;
      case "FINANCE":
        title = 'assets_lczh'.tr();
        //colorbg = LinearGradient(colors: [Color(0xFFFE5D92), Color(0xFFFE5D6C)]);
        break;
    }
    return Card(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(40)),
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12)))
            ),
        elevation: 2.0,
        child: Container(
          decoration: BoxDecoration(
            gradient:  colorbg,
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12))),
            ),
          width: ScreenUtil().setWidth(298),
          height: ScreenUtil().setHeight(202),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left:ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                width: double.infinity,
                height: ScreenUtil().setHeight(80),
                child: Text(title,style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28)),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(left:ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                color: Colors.white.withOpacity(0.2),
              ),
              Container(
                padding: EdgeInsets.only(left:ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                width: double.infinity,
                height: ScreenUtil().setHeight(102),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data.coinParticularsList[index].availableBalance.toString()+'',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din'),),
                    Text('keyongyue'.tr(),style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),)
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  TextStyle tvItemTitle = TextStyle(color:Colors.white,fontSize: ScreenUtil().setSp(29),fontFamily: 'Din');
  TextStyle tvItemValue = TextStyle(color:Colors.white.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din');


  TextStyle tvTitlesub = TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(20));
  TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din');

  Widget _renderLevel(){
    if(pyramidHomeData == null){
      return Container();
    }
    if(pyramidHomeData.communityClass != null){
      switch(pyramidHomeData.communityClass){
        case 0:
          return Text('普通用户',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.8),fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),);
          break;
        case 1:
          return Text('初级节点',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.8),fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),);
          break;
        case 2:
          return Text('中级节点',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.8),fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),);
          break;
        case 3:
          return Text('高级节点',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.8),fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),);
          break;
        case 4:
          return Text('超级节点',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.8),fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),);
          break;
      }
    }
    return  Text('普通用户',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.8),fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),);
  }

  Widget _buildPool(){
    if(pyramidHomeData == null){
      return Container();
    }
    if(pyramidHomeData.status == 1){
      return Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(120),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40),bottom: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Color(0xff273658),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('全网双星计划算力池分红',style: tvItemTitle,),
                ],
              ),
            ),
            GestureDetector(
              child:  Container(
                width: ScreenUtil().setWidth(225),
                height: ScreenUtil().setHeight(120),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("res/pyramid_icon3.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Text('   查看详情',style: TextStyle(color: Colors.white),),
                ),
              ),
              behavior: HitTestBehavior.opaque,
              onTap: (){

              },
            )
          ],
        ),
      );
    }else{
      return Container();
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        title: Text('pocs_zh'.tr()),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40)),
                child: GestureDetector(
                  child: Card(
                      color: Color(0xFF202D49),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(88),
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('兑换入口',style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28)),),
                              Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                            ],
                          )
                      )
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){

                  },
                )
              ),
              Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('节点等级',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                      _renderLevel()
                    ],
                  )
              ),
              Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('pocs_bbtaccount'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                      SmallFlatButton(text: "BBT"+'assets_hz'.tr(),canClick:true,onClick: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ChangePage();
                        })).then((value) => (){
                          if(value == 'refresh'){
                            _getAssetsDetail();
                          }
                        });
                      },),
                    ],
                  )
              ),
              Divider(),
              data == null?Container():Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(282),
                child: ListView.builder(
                  scrollDirection:Axis.horizontal,
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  itemCount: data.coinParticularsList.length, //数据的数量
                  itemBuilder: (BuildContext context,int index){
                    return  _renderCardAccount(index);
                  },
                )
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    width: double.infinity,
                    height: ScreenUtil().setHeight(120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('我的节点矿机',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('查看我的矿机',style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                            Icon(Icons.keyboard_arrow_right,color: Colors.white.withOpacity(0.6),size: ScreenUtil().setWidth(35),)
                          ],
                        )
                      ],
                    )
                ),
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StakeMinePage();
                  }));
                },
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
                          Text(pyramidHomeData !=null?pyramidHomeData.holdPosition.toString():'',style: tvTitle,),
                          Text('持仓配套总额(BBT)',style: tvTitlesub,),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(pyramidHomeData!=null?pyramidHomeData.interestSum.toString():'',style: tvTitle,),
                          Text("持仓累计收益",style: tvTitlesub,),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(pyramidHomeData!=null?pyramidHomeData.invite.toString():'',style: tvTitle,),
                          Text("推广奖励",style: tvTitlesub,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(120),
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Color(0xff273658),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('双星计划火热上线',style: tvItemTitle,),
                          Text('日收益率高达1.00%',style: tvItemValue,)
                        ],
                      ),
                    ),
                   GestureDetector(
                     child:  Container(
                       width: ScreenUtil().setWidth(225),
                       height: ScreenUtil().setHeight(120),
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: AssetImage("res/pyramid_icon1.png"),
                           fit: BoxFit.fill,
                         ),
                       ),
                       child: Center(
                         child: Text('   立即存币',style: TextStyle(color: Colors.white),),
                       ),
                     ),
                     behavior: HitTestBehavior.opaque,
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return StakeSavePage();
                       }));
                     },
                   )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(120),
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Color(0xff273658),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                      child: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('邀请有奖  ',style: tvItemTitle,),
                              ],
                            ),
                            Text('成功邀请好友奖励高达50%',style: tvItemValue,)
                          ],
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){

                        },
                      )
                    ),
                    GestureDetector(
                      child:  Container(
                        width: ScreenUtil().setWidth(225),
                        height: ScreenUtil().setHeight(120),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("res/pyramid_icon2.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: Text('   立即邀请',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return PyramidInvitePage();
                        }));
                      },
                    )
                  ],
                ),
              ),
              _buildPool(),
            ],
          ),
        ),
      ),
    );
  }
}
