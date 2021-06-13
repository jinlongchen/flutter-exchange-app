import 'dart:async';
import 'dart:convert';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/pocs_code_entity.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class PocsCodePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<PocsCodePage> {

  num approximateUSDTNUm = 0;
  num bbtnum = 0;
  num usdtnum = 0;
  num count = 1;

  bool isBBT = true;
  Timer timer;

  List<PocsCodeDataData> historyList = [];

  ScrollController _controller = new ScrollController();
  int _page = 1;
  bool hasMore = true;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    getData();
    timer = Timer.periodic(Duration(seconds: 25), (timer) {
      getData();
    });
    getHistory();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && hasMore) {
        _onLoading();
      }
    });
  }

  @override
  void dispose() {
    if(timer.isActive){
      timer.cancel();
    }
    super.dispose();
  }

  String status = '3';

  void getHistory(){
    setState(() {
      _page = 1;
      historyList = [];
      hasMore = true;
      isLoad = false;
    });
    var params = {'pageNo':1,'pageSize':20,'label':'1'};
    if(status != '3'){
      params['useStatus'] = 0;
    }
    DioManager.getInstance().post(Url.POCS_CODE_LIST, params, (data){
        PocsCodeEntity codeEntity = JsonConvert.fromJsonAsT(data);
        setState(() {
          historyList =  codeEntity.data.data;
          if(codeEntity.data.total <= 1 * 20){
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
    var params = {'pageNo':_page,'pageSize':20,'label':'1'};
    if(status != '3'){
      params['useStatus'] = 0;
    }
    DioManager.getInstance().post(Url.POCS_CODE_LIST, params, (data) async {
      PocsCodeEntity pocsListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        historyList.addAll(pocsListEntity.data.data);
        if(pocsListEntity.data.total <= _page * 20){
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

  void getData(){
    DioManager.getInstance().post(Url.POCS_PRICE, null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      setState(() {
        approximateUSDTNUm = dataMap['data']['approximateUSDTNUm'];
        bbtnum = dataMap['data']['bbtnum'];
        usdtnum = dataMap['data']['usdtnum'];
      });
    }, (error){
      CommonUtil.showToast(error);
    });
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
      if(count == 99){
        return;
      }
      setState(() {
        count = count +1;
      });
    }
  }

  void _submit(){
    _progressDialog.show();
    var params = {'number':count,'coin':isBBT?'BBT':'USDT'};
    DioManager.getInstance().post(Url.POCS_CODE_BUY, params, (data){
      _progressDialog.hide();
      CommonUtil.showToast('success'.tr());
      getHistory();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  TextStyle tvTitlesub = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvNumber = TextStyle(color: Colours.dark_textTitle,fontFamily:'Din',fontSize: ScreenUtil().setSp(28));

  Widget _renderItem(int index){
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(180),
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(historyList[index].useStatus==0?'pocs_unuse'.tr():'pocs_use'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(28),color: historyList[index].useStatus==0?Colours.dark_text_gray:Colours.dark_accent_color),),
              Text(historyList[index].createTime,style: TextStyle(fontSize: ScreenUtil().setSp(26),color: Colours.dark_text_gray.withOpacity(0.6)),)
            ],
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('price'.tr()+'('+historyList[index].coinName+')',style: tvTitlesub,),
                      Padding(
                        child: Text(historyList[index].coinMoney.toString(),style: tvNumber,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                ),
                historyList[index].useStatus == 0?Expanded(flex: 3,child: Container(),):Expanded(
                  flex:3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('pocs_user'.tr(),style: tvTitlesub,),
                      Padding(
                        child: Text(historyList[index].useUserName.toString(),style: tvNumber,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex:3,
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('pocs_jhm'.tr(),style: tvTitlesub,),
                        Padding(
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(historyList[index].buyCode.substring(0,10),style: tvNumber,),
                              Text('... '),
                              Image.asset('res/invite_copy.png',width: ScreenUtil().setWidth(20),height: ScreenUtil().setWidth(20),)
                            ],
                          ),
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        )
                      ],
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      ClipboardData data = new ClipboardData(text:historyList[index].buyCode);
                      Clipboard.setData(data);
                      CommonUtil.showToast("copy_success".tr());
                    },
                  )
                ),
              ],
            ),
          ),
          Divider()
        ],
      )
    );
  }

  TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvValue = TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din');

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
        title: Text('pocs_jhm'.tr()),
        centerTitle: false,
      ),
      body: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(92),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('pocs_code_xm'.tr(),style: tvTitle,),
                    Text('POCS',style: tvValue,)
                  ],
                ),
              ),
              Divider(),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(92),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('count'.tr(),style: tvTitle,),
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
              Divider(),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(92),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('pocs_select_pay'.tr(),style: tvTitle,),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(92),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(isBBT?'res/select_n.png':'res/select_p.png',width: ScreenUtil().setWidth(24),height: ScreenUtil().setWidth(24),),
                          Padding(
                            child:Text('BBT',style: tvValue,),
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          )
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: (bbtnum*count).toString()+' BBT ',
                                style: tvValue
                            ),
                            TextSpan(
                                text: '≈'+(approximateUSDTNUm*count).toString()+' USDT',
                                style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din')
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  setState(() {
                    isBBT = !isBBT;
                  });
                },
              ),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(92),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(!isBBT?'res/select_n.png':'res/select_p.png',width: ScreenUtil().setWidth(24),height: ScreenUtil().setWidth(24),),
                          Padding(
                            child:Text('USDT',style: tvValue,),
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          )
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: (usdtnum*count).toString()+' USDT',
                                style: tvValue
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    isBBT = !isBBT;
                  });
                },
                behavior: HitTestBehavior.opaque,
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(42)),
                width: double.infinity,
                height: ScreenUtil().setHeight(88),
                child: RaisedButton(
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                  color: Theme.of(context).accentColor,
                  child: Text("pocs_buy_code".tr()),
                  onPressed: () {
                    _submit();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                width: double.infinity,
                height: ScreenUtil().setHeight(92),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('pocs_gmjl'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32)),),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Text('type_15'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24)),),
                          Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                              child:Image.asset('res/arrow_down.png',width: ScreenUtil().setWidth(12),height: ScreenUtil().setHeight(6),color: Colours.dark_text_gray,)
                          )
                        ],
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final result = await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(ScreenUtil().setWidth(600), ScreenUtil().setHeight(900), 0.0, 0.0),
                          items: <PopupMenuItem<String>>[
                            new PopupMenuItem<String>( value: '3', child:Text('type_15'.tr()),),
                            new PopupMenuItem<String>( value: '0', child:  Text('pocs_unuse'.tr())),
                          ],
                        );
                        setState(() {
                          status = result;
                          getHistory();
                        });
                      },
                    )
                  ],
                ),
              ),
              Divider(),
              ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: new NeverScrollableScrollPhysics(),
                itemCount: historyList.length, //数据的数量
                itemBuilder: (BuildContext context,int index){
                  return  _renderItem(index);
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
