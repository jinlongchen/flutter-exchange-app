import 'dart:async';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_detail_entity.dart';
import 'package:hibi/model/pocs_info_entity.dart';
import 'package:hibi/page/contract/PocsListPage.dart';
import 'package:hibi/page/money/ChangePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/SmallFlatButton.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'PocsCodePage.dart';

class PocsPage extends StatefulWidget {
  final PocsInfoData pocsInfoData;

  const PocsPage({Key key, this.pocsInfoData}) : super(key: key);
  @override
  _State createState() => new _State();
}

class _State extends State<PocsPage> {

  AssetsDetailData data ;
  StreamSubscription  _sub;

  PocsInfoData _pocsInfoData;


  num maxData = 0;
  num curretData = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      _pocsInfoData = widget.pocsInfoData;
      curretData = num.parse( _pocsInfoData.atPresentCalculate.mirrorCalcula);
      maxData = num.parse(_pocsInfoData.atPresentCalculate.calculaWallet) *100;
      if(maxData == 0.0){
        maxData = 1;
      }
    });
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

  void getData(){

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

  TextStyle tvTitlesub = TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(20));
  TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din');


  Widget _buildBtCard(){
    return ExpandableTheme(
      data: ExpandableThemeData(
        iconColor: Colors.white
      ),
      child: ExpandableNotifier(
          child: Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40)),
            child: Card(
              color: Color(0xFF202D49),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "pocs_btsl".tr(),
                                style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28)),
                              ),
                              Text(
                                _pocsInfoData.atPresentCalculate.realCalcula,
                                style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),
                              )
                            ],
                          )),
                      expanded: Container(
                        height: ScreenUtil().setHeight(122),
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex:3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(_pocsInfoData.atPresentCalculate.calculaWallet,style: tvTitle,),
                                  Text('pocs_label1'.tr(),style: tvTitlesub,),
                                ],
                              ),
                            ),
                            Expanded(
                              flex:5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(_pocsInfoData.atPresentCalculate.finance,style: tvTitle,),
                                  Text('pocs_label2'.tr(),style: tvTitlesub,),
                                ],
                              ),
                            ),
                            Expanded(
                              flex:4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(crossFadePoint: 0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildJxCard(){
    return ExpandableTheme(
      data: ExpandableThemeData(
          iconColor: Colors.white
      ),
      child: ExpandableNotifier(
          child: Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(20)),
            child: Card(
              color: Color(0xFF202D49),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "pocs_jxsl".tr(),
                                style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28)),
                              ),
                              Text(
                                _pocsInfoData.atPresentCalculate.mirrorCalcula,
                                style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),
                              )
                            ],
                          )),
                      expanded: Container(
                        height: ScreenUtil().setHeight(244),
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30)),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: ScreenUtil().setHeight(122),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex:3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_pocsInfoData.atPresentCalculate.continuous,style: tvTitle,),
                                        Text('pocs_label3'.tr(),style: tvTitlesub,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex:5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_pocsInfoData.atPresentCalculate.promote,style: tvTitle,),
                                        Text('pocs_label4'.tr(),style: tvTitlesub,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex:4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_pocsInfoData.atPresentCalculate.community,style: tvTitle,),
                                        Text("pocs_label5".tr(),style: tvTitlesub,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: ScreenUtil().setHeight(122),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex:3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_pocsInfoData.atPresentCalculate.regist,style: tvTitle,),
                                        Text('pocs_label6'.tr(),style: tvTitlesub,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex:5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_pocsInfoData.atPresentCalculate.activity,style: tvTitle,),
                                        Text('pocs_label7'.tr(),style: tvTitlesub,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex:4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_pocsInfoData.atPresentCalculate.finance,style: tvTitle,),
                                        Text('pocs_label8'.tr(),style: tvTitlesub,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(crossFadePoint: 0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
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
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PocsListPage();
                  }));
                },
                child: Center(
                    child: Row(
                      children: <Widget>[
                        Text('pocs_history'.tr(),style: TextStyle(
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
                              Text('pocs_jhm'.tr(),style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28)),),
                              Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                            ],
                          )
                      )
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PocsCodePage();
                    }));
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
              Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('pocs_wdsl'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                      Text(_pocsInfoData.myAllCalcula,style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),)
                    ],
                  )
              ),
              Divider(),
              _buildBtCard(),
              _buildJxCard(),
              Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('pocs_slkj'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                    ],
                  )
              ),
              Padding(
                child: Divider(),
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
              ),
              _pocsInfoData == null?Container():
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(10),
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(48)),
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                        child: SizedBox(
                            width: ScreenUtil().setWidth(686),
                            height: ScreenUtil().setHeight(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: LinearProgressIndicator(
                                value:curretData/maxData,
                                backgroundColor: Colours.dark_text_gray.withOpacity(0.3),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: ScreenUtil().setWidth(32)+(curretData/maxData * ScreenUtil().setWidth(686) - ScreenUtil().setWidth(8)),
                    top: ScreenUtil().setHeight(30),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset('res/chg_down.png',width: ScreenUtil().setWidth(12),height: ScreenUtil().setHeight(8),color: Colours.dark_accent_color,)
                      ],
                    ),
                  ),
                  Positioned(
                    left: ScreenUtil().setWidth(32)+(curretData/maxData * ScreenUtil().setWidth(686) -( curretData==0.0?ScreenUtil().setWidth(8):ScreenUtil().setWidth(30))),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(curretData.toString(),style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(48),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('pocs_jxslsx'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(20)),),
                          ],
                        ),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(7)),
                      ),
                      Positioned(
                        left: ScreenUtil().setWidth(686)/4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(2),
                              height: ScreenUtil().setHeight(4),
                              color: Colours.dark_text_gray.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: ScreenUtil().setHeight(10),
                        left: ScreenUtil().setWidth(686)/4-ScreenUtil().setWidth(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('pocs_zkx'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(20)),)
                          ],
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40),bottom: ScreenUtil().setHeight(60)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('pocs_zkx'.tr(),style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28)),),
                    Padding(
                      padding: EdgeInsets.only(top: 8,bottom: 3),
                      child:Text('pocs_btsl'.tr()+'x25',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child:Text('pocs_zkx_label'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))),
                    ),
                    Text('pocs_jxslsx'.tr(),style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28))),
                    Padding(
                      padding: EdgeInsets.only(top: 8,bottom: 3),
                      child:Text('pocs_btsl'.tr()+'x100',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24))),
                    ),
                    Text('pocs_jxslsx_label'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
