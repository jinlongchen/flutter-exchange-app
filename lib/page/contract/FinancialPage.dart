import 'dart:async';
import 'dart:convert';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_detail_entity.dart';
import 'package:hibi/model/pocs_info_entity.dart';
import 'package:hibi/model/pyramid_home_entity.dart';
import 'package:hibi/page/WebPage.dart';
import 'package:hibi/page/activity/PyramidPage.dart';
import 'package:hibi/page/contract/PocsPage.dart';
import 'package:hibi/page/activity/PyramidSavePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class FinancialPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<FinancialPage> {
  PocsInfoData pocsInfoData;
  PyramidHomeData pyramidHomeData;

  String aboutUSDTMoney = '';
  String abcoutUSDTMoneyUSDT = '';

  AssetsDetailData data ;

  bool isPocs = false;
  bool isLoading = true;


  Future _getAssetsDetail() async{
    var params = {'symbol':"USDT"};
    DioManager.getInstance().post(Url.ASSETS_DETAIL, params, (data2){
      AssetsDetailEntity assetsDetailEntity = JsonConvert.fromJsonAsT(data2);
      setState(() {
        data = assetsDetailEntity.data;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  StreamSubscription  _sub;

  @override
  void initState() {
    super.initState();
    _sub = eventBus.on<RefreshPyramidSave>().listen((event) {
      getData();
    });
    getData();
    _getAssetsDetail();
  }


  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void getData(){
    DioManager.getInstance().post(Url.PYRAMID_HOME, null, (data){
      PyramidHomeEntity pyramidHomeEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        pyramidHomeData = pyramidHomeEntity.data;
        isPocs = true;
        isLoading = false;
      });
    }, (error){
      CommonUtil.showToast(error);
    });
   /* DioManager.getInstance().post(Url.POCS_CHECK, null, (date2){
      String dataStr = json.encode(date2);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      bool hasPocs = dataMap['data'];
      if(hasPocs){
        DioManager.getInstance().post(Url.POCS_INFO, null, (data){
          PocsInfoEntity pocsInfoEntity = JsonConvert.fromJsonAsT(data);
          setState(() {
            pocsInfoData = pocsInfoEntity.data;
            getPocsReside();
          });
        }, (error){
          CommonUtil.showToast(error);
        });

        DioManager.getInstance().post(Url.PYRAMID_HOME, null, (data){
          PyramidHomeEntity pyramidHomeEntity = JsonConvert.fromJsonAsT(data);
          setState(() {
            pyramidHomeData = pyramidHomeEntity.data;
          });
        }, (error){
          CommonUtil.showToast(error);
        });
      }
      setState(() {
        isPocs = hasPocs;
        isLoading = false;
      });
    }, (error2){
      CommonUtil.showToast(error2);
    });*/
  }

  void getPocsReside(){
    var params = {'aboutUSDTMoney':pocsInfoData.aboutUSDTMoney,'abc':"1"};
    DioManager.getInstance().post(Url.POCS_RESIDUE, params, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      Decimal count = Decimal.tryParse(dataMap['data'].toString());
      setState(() {
        abcoutUSDTMoneyUSDT = count.toString();
      });
    }, (error){
      CommonUtil.showToast(error);
    });

    var params2 = {'expectedPurchaseNumber':pocsInfoData.expectedPurchaseNumber,'price':pocsInfoData.price};
    DioManager.getInstance().post('/pocs/pocsPurchase/residueBBT', params2, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      setState(() {
        aboutUSDTMoney = dataMap['data'].toString();
      });
      print(dataMap['data'].toString());
    }, (error){

    });
  }

  void purchaseOrder(){
    _progressDialog.show();
    var params = {'number':_count.text,'purchaseId':'2','aboutmoneys':pocsInfoData.aboutUSDTMoney};
    DioManager.getInstance().post(Url.POCS_ORDER, params, (data){
      _progressDialog.hide();
      setState(() {
        _bbt.text = "";
        _count.text = "";
      });
      CommonUtil.showToast('success'.tr());
      getData();
      _getAssetsDetail();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }


  formatNum(double num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      return num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }else{
      return num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }
  }

  final TextEditingController _count = new TextEditingController();
  final TextEditingController _bbt = new TextEditingController();

  void purchase(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colours.dark_bg_gray,
        isScrollControlled: true,
        builder: (BuildContext context){
          return AnimatedPadding(
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(900),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(140),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('POCS'+'pocs_sg'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(40)),),
                        GestureDetector(
                          child: Image.asset('res/close.png',width: ScreenUtil().setWidth(32),height: ScreenUtil().setWidth(32),),
                          onTap: (){
                            setState(() {
                              _bbt.text = "";
                              _count.text = "";
                            });
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'count'.tr(),
                                    style:TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))
                                ),
                              ],
                            )
                        ),
                        TextField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp(r"[\d.]"))
                          ],
                          onChanged: (e){
                            if(CommonUtil.isEmpty(e)){
                              setState(() {
                                _count.text = "";
                              });
                            }
                            Decimal price = Decimal.tryParse(pocsInfoData.nowPurchasePrice);
                            Decimal realCount = Decimal.tryParse(e) * price;
                            setState(() {
                              _count.text = realCount.toString();
                            });
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: _bbt,
                          autofocus: false,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontFamily: 'Din'
                          ),
                          decoration:InputDecoration(
                              hintText: 'pocs_qsrsgsl'.tr(),
                              contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                              suffixIcon: Container(
                                width: ScreenUtil().setWidth(200),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          _bbt.text = aboutUSDTMoney;
                                        });
                                        Decimal price = Decimal.tryParse(pocsInfoData.nowPurchasePrice);
                                        Decimal realCount = Decimal.tryParse(aboutUSDTMoney) * price;
                                        setState(() {
                                          _count.text = formatNum(realCount.toDouble(), 2);
                                        });
                                      },
                                      child: Text('全部',style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Color(0xffe0e0e7)),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                                    ),
                                    Text("BBT",style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Color(0xffe0e0e7)),),
                                  ],
                                ),
                              )
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('pocs_jrsy'.tr()+":"+aboutUSDTMoney+" BBT",style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),)
                            ],
                          ),
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        ),
                        Container(
                            padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'money'.tr(),
                                    style:TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))
                                ),
                              ],
                            )
                        ),
                        TextField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp(r"[\d.]"))
                          ],
                          onChanged: (e){

                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: _count,
                          autofocus: false,
                          enabled: false,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontFamily: 'Din'
                          ),
                          decoration:InputDecoration(
                              contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                              suffixIcon: Container(
                                width: ScreenUtil().setWidth(200),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("USDT",style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Color(0xffe0e0e7)),),
                                  ],
                                ),
                              )
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('keyongyue'.tr()+":"+data.availableBalance.toString()+" USDT",style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),)
                            ],
                          ),
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(42)),
                          width: double.infinity,
                          height: ScreenUtil().setHeight(88),
                          child: RaisedButton(
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                            color: Theme.of(context).accentColor,
                            child: Text("submit".tr()),
                            onPressed: () {
                              Navigator.of(context).pop();
                              purchaseOrder();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  final TextEditingController _code = new TextEditingController();

  void activePocsReal(){
    if(CommonUtil.isEmpty(_code.text)){
      return;
    }

    _progressDialog.show();
    var params = {'code':_code.text};
    DioManager.getInstance().post(Url.POCS_CODE_USE, params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      getData();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  void activePocs(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colours.dark_bg_gray,
        isScrollControlled: true,
        builder: (BuildContext context){
          return AnimatedPadding(
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(550),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(140),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('POCS'+'pocs_jh'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(40)),),
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
                    width: double.infinity,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'pocs_jhm'.tr(),
                                    style:TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))
                                ),
                              ],
                            )
                        ),
                        TextField(
                          controller: _code,
                          autofocus: false,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontFamily: 'Din'
                          ),
                          decoration:InputDecoration(
                              contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(42)),
                          width: double.infinity,
                          height: ScreenUtil().setHeight(88),
                          child: RaisedButton(
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                            color: Theme.of(context).accentColor,
                            child: Text("submit".tr()),
                            onPressed: () {
                              Navigator.of(context).pop();
                              activePocsReal();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget renderPocs(){
    if(isLoading){
      return Container();
    }
    if(isPocs){
      if(pocsInfoData == null){
        return Container();
      }else{
        return Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('res/icon_pocs.png',width: ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                              child:Text('POCS',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: Row(
                            children: <Widget>[
                              Text('pocs_zh'.tr(),style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28)),),
                              Icon(Icons.keyboard_arrow_right,color: Colours.dark_accent_color,)
                            ],
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return PocsPage(pocsInfoData: pocsInfoData,);
                            }));
                          },
                        )
                      ],
                    )
                ),
                Divider(),
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(142),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(pocsInfoData.averagePrice.toString(),style: tvTitle,),
                            Text('pocs_scjj'.tr(),style: tvTitlesub,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(pocsInfoData.nowPurchasePrice,style: tvTitle,),
                            Text('pocs_sgj'.tr(),style: tvTitlesub,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(pocsInfoData.nowDiscount,style: tvTitle,),
                            Text("pocs_sgzk".tr(),style: tvTitlesub,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(142),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(pocsInfoData.atPresentCalculate.allCalcula,style: tvTitle,),
                            Text('pocs_qwzsl'.tr(),style: tvTitlesub,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(pocsInfoData.expectedPurchaseNumber,style: tvTitle,),
                            Text('pocs_jrsged'.tr()+'(BBT)',style: tvTitlesub,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:4,
                        child: Column(

                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  width: ScreenUtil().setWidth(686),
                  height: ScreenUtil().setHeight(68),
                  decoration: BoxDecoration(
                      color: Color(0xFF202D49),
                      borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: Text('text_pocs'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                ),
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(156),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(aboutUSDTMoney+' BBT',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din'),),
                              Text('≈'+abcoutUSDTMoneyUSDT+' USDT',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                            child:Text('pocs_jrsy'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(20)),),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child:  Container(
                          width: ScreenUtil().setWidth(152),
                          height: ScreenUtil().setHeight(76),
                          decoration: BoxDecoration(
                              color: Colours.dark_accent_color,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Text('pocs_sg'.tr()),
                          alignment: Alignment.center,
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          purchase();
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
        );
      }
    }else{
      return Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
          child: Column(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset('res/icon_pocs.png',width: ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),),
                          Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                            child:Text('POCS',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child:  Container(
                          width: ScreenUtil().setWidth(152),
                          height: ScreenUtil().setHeight(76),
                          decoration: BoxDecoration(
                              color: Colours.dark_accent_color,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Text('pocs_jh'.tr()),
                          alignment: Alignment.center,
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          activePocs();
                        },
                      )
                    ],
                  )
              ),
            ],
          )
      );
    }
  }

  Widget _renderIPFS(){
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(120),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('res/icon_ipfs.png',width: ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child:Text('IPFS万有引力计划',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Text('查看说明',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24)),),
                        Icon(Icons.keyboard_arrow_right,color: Colours.dark_text_gray,size: ScreenUtil().setWidth(36),)
                      ],
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return WebPage(url: "https://hibisupport.zendesk.com/hc/zh-hk/articles/900002178306-IPFS%E4%B8%87%E6%9C%89%E5%BC%95%E5%8A%9B%E8%AE%A1%E5%88%92",);
                      }));
                    },
                  )
                ],
              )
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(26),bottom: ScreenUtil().setHeight(26)),
            child: Text('分享下一代互联网红利 ，HiBi将与世界顶尖的数据产业机构合作，打造Filecoin数据中心。',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
          ),
        ],
      ),
    );
  }

  Widget _renderBBT(){
    if(isLoading){
      return Container();
    }
    if(isPocs){
      if(pyramidHomeData == null){
        return Container();
      }else{
        return Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('res/icon_bbt.png',width: ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                              child:Text('Binary Star System 双星计划',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: Row(
                            children: <Widget>[
                              Text('pocs_zh'.tr(),style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28)),),
                              Icon(Icons.keyboard_arrow_right,color: Colours.dark_accent_color,)
                            ],
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return PyramidPage();
                            }));
                          },
                        )
                      ],
                    )
                ),
                Divider(),
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(142),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(pyramidHomeData.holdPosition.toString(),style: tvTitle,),
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
                            Text(pyramidHomeData.interestSum.toString(),style: tvTitle,),
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
                            Text(pyramidHomeData.invite.toString(),style: tvTitle,),
                            Text("推广奖励",style: tvTitlesub,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  width: ScreenUtil().setWidth(686),
                  height: ScreenUtil().setHeight(68),
                  decoration: BoxDecoration(
                      color: Color(0xFF202D49),
                      borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: Text('text_pyramid'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                ),
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(156),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(pyramidHomeData.pocsIncrease,style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din'),),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                            child:Text('POCS算力周增长',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(20)),),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child:  Container(
                          width: ScreenUtil().setWidth(152),
                          height: ScreenUtil().setHeight(76),
                          decoration: BoxDecoration(
                              color: Colours.dark_accent_color,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Text('立即存入'),
                          alignment: Alignment.center,
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PyramidSavePage();
                          }));
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
        );
      }
    }else{
      return Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
          child: Column(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset('res/icon_bbt.png',width: ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),),
                          Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                            child:Text('Binary Star System 双星计划',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child:  Container(
                          width: ScreenUtil().setWidth(152),
                          height: ScreenUtil().setHeight(76),
                          decoration: BoxDecoration(
                              color: Colours.dark_accent_color,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Text('pocs_jh'.tr()),
                          alignment: Alignment.center,
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          activePocs();
                        },
                      )
                    ],
                  )
              ),
            ],
          )
      );
    }
  }

  TextStyle tvTitlesub = TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(20));
  TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din');

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
    return  Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        title: Text('home_lc'.tr()),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(20)),
                  child:Image.asset('res/contract_banner.png',width: ScreenUtil().setWidth(686),height: ScreenUtil().setHeight(160),fit: BoxFit.fill,)
              ),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(120),
                child: Text('pocs_zhlb'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32)),),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
              ),
              Divider(),
              renderPocs(),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(20),
                color: Colours.dark_bg_color,
              ),
              _renderBBT(),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(20),
                color: Colours.dark_bg_color,
              ),
              _renderIPFS(),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(20),
                color: Colours.dark_bg_color,
              ),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(200),
                child: Center(
                  child: Text('pocs_please'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din')),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
