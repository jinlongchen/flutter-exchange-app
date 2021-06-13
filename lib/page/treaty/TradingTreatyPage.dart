import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/common/mqtt.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/TransObject.dart';
import 'package:hibi/model/TransObjectList.dart';
import 'package:hibi/model/assets_balance_entity.dart';
import 'package:hibi/model/order_list_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/page/trading/KLinePage.dart';
import 'package:hibi/page/trading/OrderListPage.dart';
import 'package:hibi/page/trading/trading_drawer.dart';
import 'package:hibi/page/user/LoginPage.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/EmptyView.dart';
import 'package:hibi/widget/PrecisionLimitFormatter.dart';
import 'package:hibi/widget/PriceItem.dart';
import 'package:hibi/widget/SmallFlatButton.dart';
import 'package:hibi/widget/SmallRiseFullButton.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class TradingTreatyPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<TradingTreatyPage>  {


  String name = "ETH_USDT";
  String type = "buy";
  String fromName = "ETH";
  String toName = "USDT";
  String fromNameCount = '0';
  String toNameCount = '0';
  String fromNameCountLabel = '0';
  String toNameCountLabel = '0';
  num price_changed = 0;


  final TextEditingController _price = new TextEditingController();
  final TextEditingController _count = new TextEditingController();
  double count_value_percent = 0.0;
  int commodityReserveCount = 4;
  int settleReserveCount = 4;

  SymbolListData curretItem;

  StreamSubscription  _sub;
  //depth
  StreamSubscription  _sub2;
  //refresh
  StreamSubscription  _sub3;



  List<TransObject> listAsks = [];
  List<TransObject> listBids = [];
  int transCount = 5;

  String tradeType = 'XJ';


  List<OrderListDataData> historyList = [];


  @override
  void initState() {
    super.initState();
    _sub = eventBus.on<RefreshCurretSymbol>().listen((event) {
      initData();
    });
    _sub2 = eventBus.on<SocketDepth>().listen((event) {
      _renderDepth(event.data,true);
    });
    _sub3 = eventBus.on<ChangeTradeType>().listen((event) {
      setState(() {
        type = event.type;
      });
    });
    initData();
    _startLoop();
  }

  Timer timer;
  void _startLoop(){
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      initHistory();
    });
  }

  void initAssest(){
    if(!Provider.of<UserInfoState>(context, listen: false).isLogin){
      return;
    }
    DioManager.getInstance().post(Url.WALLET_ASSEST, null, (data){
      AssetsBalanceEntity assetsBalanceEntity = JsonConvert.fromJsonAsT(data);
      for(AssetsBalanceData item in assetsBalanceEntity.data){
        if(item.coin.name == curretItem.coinSymbol){
          setState(() {
            fromNameCount = item.balance.toString();
          });
        }
        if(item.coin.name == curretItem.baseSymbol){
          setState(() {
            toNameCount = item.balance.toString();
          });
        }
      }
    }, (error){
        CommonUtil.showToast(error);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _sub2.cancel();
    _sub3.cancel();
    if(timer.isActive){
      timer.cancel();
    }
    super.dispose();
  }

  _submit(){
    if(CommonUtil.isEmpty(_count.text)){
      CommonUtil.showToast('order_qsrsl'.tr());
      return;
    }
    if(tradeType == 'XJ'){
      if(CommonUtil.isEmpty(_price.text)){
        CommonUtil.showToast('order_qsrjg'.tr());
        return;
      }
    }

    FocusScope.of(context).requestFocus(FocusNode());

    if(!Provider.of<UserInfoState>(context, listen: false).isLogin){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
      return;
    }

    var params = {
      'direction':type=='buy'?"BUY":"SELL",
      'symbol':curretItem.symbol,
      'amount':num.parse(_count.text),
      'type':tradeType == 'XJ'?1:0
    };
    if(tradeType == 'XJ'){
      params['price'] = num.parse(_price.text);
    }
    _progressDialog.show();
    DioManager.getInstance().post(Url.EXCHANGE_ORDER_ADD, params, (data){
      _progressDialog.hide();
      eventBus.fire(new RefreshAsstes());
      setState(() {
        _count.text = '';
        _price.text = '';
        count_value_percent = 0.0;
      });
      initData();
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  void initData(){
    curretItem = Provider.of<SymbolState>(context, listen: false).getCurretSymbol();
    setState(() {
      name = curretItem.symbol;
      fromName = curretItem.coinSymbol;
      toName = curretItem.baseSymbol;
      settleReserveCount = curretItem.baseScale;
      commodityReserveCount = curretItem.coinScale;
    });
    initDepth();
    initAssest();
    initHistory();
  }

  void initHistory(){
   try{
     if(!Provider.of<UserInfoState>(context, listen: false).isLogin){
       return;
     }
     var params = {'symbol':curretItem.symbol,'pageNo':1,'pageSize':20};
     DioManager.getInstance().post(Url.EXCHANGE_ORDER_LIST, params, (data){
       OrderListEntity orderListEntity = JsonConvert.fromJsonAsT(data);
       setState(() {
         historyList = orderListEntity.data.data;
       });
     }, (error){
       timer.cancel();
     });
   }catch(e){
     timer.cancel();
   }
  }

  void initDepth(){
    var params = {'symbol':name};
    DioManager.getInstance().post(Url.MARKET_DEPTH, params, (data){
      _renderDepth(json.encode(data),false);
      MqttUtils.getInstance().subscribe("/topic/MARKET_DEPTH_"+name);
    }, (error){
      CommonUtil.showToast(error);
    });
  }

  _renderDepth(String data,bool isSocket){
    Map<String, dynamic> dataMap = json.decode(data);
    List<TransObject> listAskss = [];
    List<TransObject> listBidss = [];
    List<dynamic> asks = [];
    List<dynamic> bids = [];
    if(isSocket){
      asks = dataMap['sell'];
      bids = dataMap['buy'];
    }else{
      asks = dataMap['data']['sell'];
      bids = dataMap['data']['buy'];
    }
    int count1 = asks.length > transCount?transCount:asks.length;
    int count2 = bids.length > transCount?transCount:bids.length;
    for(int i=0;i<count1;i++){
      TransObject transObject = new TransObject();
      transObject.price = asks[i][0];
      transObject.volumn = asks[i][1];
      listAskss.add(transObject);
    }
    for(int i=0;i<count2;i++){
      TransObject transObject = new TransObject();
      transObject.price = bids[i][0];
      transObject.volumn = bids[i][1];
      listBidss.add(transObject);
    }

    listAskss.sort((left,right)=>right.price.compareTo(left.price));
    setState(() {
      listAsks = listAskss;
      listBids = listBidss;
    });
  }

  Widget _renderChangedText(){
    if(price_changed >= 0){
      return(Text('('+price_changed.toString()+'%)',style: TextStyle(color: Config.greenColor,fontSize: ScreenUtil().setSp(20)),));
    }else{
      return(Text('('+price_changed.toString()+'%)',style: TextStyle(color: Config.redColor,fontSize: ScreenUtil().setSp(20)),));
    }
  }

  String _renderPercent(double percent){
    return percent.toInt().toString()+'%';
  }

  String _renderPriceFinal(){
    if(!CommonUtil.isEmpty(_price.text)){
      if(!CommonUtil.isEmpty(_count.text)){
        num price = num.parse(_price.text);
        num count = num.parse(_count.text);
        num all = price * count;
        String allstr = all.toString();
        List<String> allstrs = allstr.split('.');
        if(allstrs.length > 1){
          if(allstrs[1].length < settleReserveCount){
            return all.toString();
          }else{
            return all.toStringAsFixed(settleReserveCount);
          }
        }else{
          return all.toString();
        }
      }
    }
    return '0';
  }

  String _renderCNYMean(){
    if(!CommonUtil.isEmpty(_price.text)){
      num price = num.parse(_price.text);
      num CNY = price * curretItem.priceCNY;
      return CNY.toStringAsFixed(2);
    }
    return '0.00';
  }

  void _onSliderChange(double percent){
    num count = num.parse(fromNameCount);
    if(tradeType != 'XJ'){
      if(type == 'buy'){
        num maxCount = num.parse(toNameCount);
        setState(() {
          _count.text =(maxCount *percent/100).toString();
        });
      }else{
        setState(() {
          _count.text = (count *percent/100).toStringAsFixed(commodityReserveCount);
        });
      }
    }else{
      if(type == 'buy'){
        if(!CommonUtil.isEmpty(_price.text)){
          num price = num.parse(_price.text);
          num maxCount = num.parse(toNameCount);
          num canbuy = maxCount/price;
          String canbuyStr = (canbuy *percent/100).toStringAsFixed(commodityReserveCount+1);
          setState(() {
            _count.text = canbuyStr.substring(0,canbuyStr.lastIndexOf('.')+commodityReserveCount+1);
          });
        }
      }else{
        String cansellStr = (count *percent/100).toStringAsFixed(commodityReserveCount+1);
        setState(() {
          _count.text = cansellStr.substring(0,cansellStr.lastIndexOf('.')+commodityReserveCount+1);
        });
      }
    }
    setState(() {
      count_value_percent = percent;
    });
  }

  _addCount(int type){
    num offset= 1;
    switch(settleReserveCount){
      case 0:
        offset = 1;
        break;
      case 1:
        offset = 0.1;
        break;
      case 2:
        offset = 0.01;
        break;
      case 3:
        offset = 0.001;
        break;
      case 4:
        offset = 0.0001;
        break;
      case 5:
        offset = 0.00001;
        break;
      case 6:
        offset = 0.000001;
        break;
      case 7:
        offset = 0.0000001;
        break;
      case 8:
        offset = 0.00000001;
        break;
      default:
        offset = 0.00000001;
        break;
    }
    num realPrice = 0;
    if(!CommonUtil.isEmpty(_price.text)){
      realPrice = num.tryParse(_price.text);
    }

    num offsetPrice = 0;
    if(type == 0){
      offsetPrice = realPrice - offset;
    }else{
      offsetPrice = realPrice + offset;
    }

    if(offsetPrice < 0){
      offsetPrice = 0;
    }

    String text = '';

    String allstr = offsetPrice.toString();
    List<String> allstrs = allstr.split('.');
    if(allstrs.length > 1){
      if(allstrs[1].length < settleReserveCount){
        text =  offsetPrice.toString();
      }else{
        text =  offsetPrice.toStringAsFixed(settleReserveCount);
      }
    }else{
      text = offsetPrice.toString();
    }

    setState(() {
      _price.text = text;
    });
  }

  String _renderCountType(){
      if(tradeType == 'XJ'){
        return fromName;
      }else{
        if(type == 'buy'){
          return toName;
        }else{
          return fromName;
        }
      }
  }

  Color borderColor = Color(0xFFE0E0E7).withOpacity(0.3);
  Color hintTextColor = Color(0xFF4C4E5B);

  Widget _buildLeft(){
    return(Container(
      width: ScreenUtil().setWidth(412),
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top:ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:GestureDetector(
                        onTap: (){ setState(() {
                          type = 'buy';
                          _count.text = '';
                          _price.text = '';
                          count_value_percent = 0;
                        });},
                        child: ClipPath(
                          child:  type == 'buy'?
                          Container(
                              height: ScreenUtil().setHeight(72),
                              color: Config.greenColor,
                              child: Center(
                                child: Text('buy'.tr(),style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),),
                              )
                          ):
                          Container(
                              color: Colours.dark_bg_gray_,
                              height: ScreenUtil().setHeight(72),
                              child: Center(
                                child: Text('buy'.tr(),style: TextStyle(color: Colours.dark_text_grey2,fontSize: ScreenUtil().setSp(28)),),
                              )
                          ),
                          clipper: LeftClip(),//主要部分
                        ),
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){setState(() {
                          type = 'sale';
                          _count.text = '';
                          _price.text = '';
                          count_value_percent = 0;
                        });},
                        child: ClipPath(
                          child:  type == 'buy'?
                          Container(
                              color: Colours.dark_bg_gray_,
                              height: ScreenUtil().setHeight(72),
                              child: Center(
                                child: Text('sale'.tr(),style: TextStyle(color: Colours.dark_text_grey2,fontSize: ScreenUtil().setSp(28)),),
                              )
                          ):
                          Container(
                              height: ScreenUtil().setHeight(72),
                              color: Config.redColor,
                              child: Center(
                                child: Text('sale'.tr(),style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold),),
                              )
                          ),
                          clipper: RightClip(),//主要部分
                        ),
                      )
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(26)),
              child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(48),
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: borderColor, width: ScreenUtil().setWidth(2)), // 边色与边宽度
                    borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))), // 也可控件一边圆角大小
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(tradeType == 'XJ'?'trade_xj'.tr():'trade_sj'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24)),),
                      Icon(Icons.keyboard_arrow_down,size: ScreenUtil().setHeight(20),color: Color(0xffbdbdc9),)
                    ],
                  ),
                ),
                onTap: () async {
                  final result = await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(ScreenUtil().setWidth(32),ScreenUtil().setHeight(390), 100.0, 100.0),
                      items: <PopupMenuItem<String>>[
                        new PopupMenuItem<String>( value: 'XJ', child:Text('trade_xj'.tr()),),
                        new PopupMenuItem<String>( value: 'SJ', child:  Text('trade_sj'.tr())),
                      ],
                  );
                  if(result != null){
                    setState(() {
                      tradeType = result;
                    });
                  }
                },
              )
            ),
            tradeType == 'XJ'?
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(72),
                decoration: new BoxDecoration(
                  border: new Border.all(color: borderColor, width: ScreenUtil().setWidth(2)),
                  borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(226),
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [PrecisionLimitFormatter(settleReserveCount)],
                            controller: _price,
                            autofocus: false,
                            style: TextStyle(
                              color:Colors.white,
                              fontFamily: 'Din',
                              fontSize: ScreenUtil().setSp(28),
                            ),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.0),
                                ),
                                hintText: "price".tr(),
                                hintStyle: TextStyle(color: hintTextColor),
                                contentPadding: EdgeInsets.only(top: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(15))
                            ),
                          ),
                        )
                    ),
                    Container(
                      width: ScreenUtil().setWidth(2),
                      height: double.infinity,
                      color: borderColor,
                    ),
                    Container(
                      width: ScreenUtil().setWidth(140),
                      height: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex:1,
                              child: GestureDetector(
                                child: Center(
                                    child: Icon(Icons.remove,color: Colours.dark_text_gray.withOpacity(0.8),size: ScreenUtil().setWidth(36),)
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  _addCount(0);
                                },
                              )
                          ),
                          Expanded(
                              flex:1,
                              child:GestureDetector(
                                child: Center(
                                    child: Icon(Icons.add,color: Colours.dark_text_gray.withOpacity(0.8),size: ScreenUtil().setWidth(36),)
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  _addCount(1);
                                },
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ):Container(),
            tradeType == 'XJ'?
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
              child: Text('≈'+_renderCNYMean()+' CNY',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
            ):Container(),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(22)),
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(72),
                decoration: new BoxDecoration(
                  border: new Border.all(color: borderColor, width: ScreenUtil().setWidth(2)),
                  borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(250),
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [PrecisionLimitFormatter(commodityReserveCount)],
                            controller: _count,
                            autofocus: false,
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: ScreenUtil().setSp(28),
                              fontFamily: 'Din'
                            ),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colours.dark_bg_gray,
                                      width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.0),
                                ),
                                hintText: tradeType == 'XJ'?'count'.tr():type == 'buy'?'volume'.tr():'count'.tr(),
                                hintStyle: TextStyle(color: hintTextColor),
                                contentPadding: EdgeInsets.only(top: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(15))
                            ),
                          ),
                        )
                    ),
                    Container(
                        width: ScreenUtil().setWidth(90),
                        height: double.infinity,
                        padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                        child: Center(
                          child: Text(_renderCountType(),style: TextStyle(
                            color:hintTextColor,
                            fontSize: ScreenUtil().setSp(24),
                            fontFamily: 'Din'
                          ),),
                        )
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('keyongyue'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))),
                  Text(type=='buy'?toNameCount+toName.toUpperCase():fromNameCount+fromName.toUpperCase(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din')),
                ],
              )
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(10)),
              child: SliderTheme( //自定义风格
                data: SliderTheme.of(context).copyWith(
                    activeTrackColor: type == 'buy'?Colours.dark_accent_color:Config.redColor, //进度条滑块左边颜色
                    inactiveTrackColor: Color(0xffd8d8d8), //进度条滑块右边颜色
                    thumbColor: type == 'buy'?Colours.dark_accent_color:Config.redColor,
                    thumbShape: RoundSliderThumbShape(//可继承SliderComponentShape自定义形状
                      disabledThumbRadius: 5, //禁用是滑块大小
                      enabledThumbRadius: 5, //滑块大小
                    ),
                    overlayShape: RoundSliderOverlayShape(//可继承SliderComponentShape自定义形状
                      overlayRadius: 0, //滑块外圈大小
                    ),
                    showValueIndicator: ShowValueIndicator.onlyForDiscrete,//气泡显示的形式
                    valueIndicatorColor: type == 'buy'?Colours.dark_accent_color:Config.redColor,//气泡颜色
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),//气泡形状
                    valueIndicatorTextStyle: TextStyle(color: Colors.white),//气泡里值的风格
                    trackHeight: 1 //进度条宽度
                ),
                child: Slider(
                  value: count_value_percent,
                  onChanged: (v) {
                    _onSliderChange(v);
                  },
                  label: _renderPercent(count_value_percent),//气泡的值
                  divisions: 100, //进度条上显示多少个刻度点
                  max: 100,
                  min: 0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('0%',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(20)),),
                  Text('100%',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(20)),),
                ],
              ),
            ),
            tradeType == 'XJ' ?
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              height: ScreenUtil().setHeight(65),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('volume'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                  Row(
                    children: <Widget>[
                      Text(_renderPriceFinal(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24)),),
                      Text(toName.toUpperCase(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24)),),
                    ],
                  )
                ],
              ),
            ):Container(),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Center(
                  child:SizedBox(
                    width: ScreenUtil().setWidth(380),
                    height: ScreenUtil().setHeight(76),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.all(0.0),
                      child: Text(type=='buy'?'buy'.tr():'sale'.tr(),style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        _submit();
                      },
                      elevation: 4.0,
                      color: type=='buy'?Config.greenColor:Config.redColor,
                    ),
                  )
              ),
            )
          ],
        ),
      )
    ));
  }

  Widget _buildPirceItem(TransObject item,int index){
    num allNum = 0;
    for(int j = index;j<listAsks.length;j++){
      allNum = allNum+listAsks[j].volumn;
    }
    num baseNum = 0;
    for(int j = 0;j<listAsks.length;j++){
      baseNum = baseNum+listAsks[j].volumn;
    }
    num offset2 = allNum/baseNum;
    return PriceItem(itemObject: item,offset: offset2,onSetPrice: (value){
      setPrice(value);
    },isRise:true);
  }

  Future<void> setPrice(String price) async {
    if (await Vibration.hasCustomVibrationsSupport() && Platform.isAndroid) {
     Vibration.vibrate(duration: Config.vibrateTime, amplitude: Config.vibrateAmp);
    }
    setState(() {
      _price.text = price;
    });
  }

  Widget _buildPirceItemBids(TransObject item,int index){
    num allNum = 0;
    for(int j = 0;j<index+1;j++){
      allNum = allNum+listBids[j].volumn;
    }
    num baseNum = 0;
    for(int j = 0;j<listBids.length;j++){
      baseNum = baseNum+listBids[j].volumn;
    }
    num offset2 = allNum/baseNum;

    return PriceItem(itemObject: item,offset: offset2,onSetPrice: (value){
      setPrice(value);
    },isRise:false);
  }

  Widget _buildTrans(){
    List<Widget> transAsks = [];
    List<Widget> transBids = [];

    for(int i=0;i<listAsks.length;i++){
      transAsks.add(_buildPirceItem(listAsks[i],i));
    }
    for(int i=0;i<listBids.length;i++){
      transBids.add(_buildPirceItemBids(listBids[i],i));
    }

    return(Container(
      width: ScreenUtil().setWidth(338),
      height: double.infinity,
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('price'.tr(),style: TextStyle(color: Config.textGrey,fontSize: ScreenUtil().setSp(20)),),
                Text('count'.tr(),style: TextStyle(color: Config.textGrey,fontSize: ScreenUtil().setSp(20)),)
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(246),
            child: Column(
                children: transAsks
            ),
          ),
          GestureDetector(
            child: Container(
              height: ScreenUtil().setHeight(130),
              width: double.infinity,
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(curretItem.close.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(32),color: Config.greenColor,fontFamily: 'Din'),),
                  Text('≈'+CommonUtil.calcCny(curretItem.close, curretItem.priceCNY)+' CNY',style: TextStyle(fontSize: ScreenUtil().setSp(24),color: Color(0xFF5B606E),fontFamily: 'Din'),),
                ],
              ),
            ),
            onTap: (){
              setPrice(curretItem.close.toString());
            },
            behavior: HitTestBehavior.opaque,
          ),
          Container(
            height: ScreenUtil().setHeight(246),
            child: Column(
                children: transBids
            ),
          ),
        ],
      ),
    ));
  }

  String renderTimeHistory(int timestamp){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return CommonUtil.pad(date.hour.toString())+":"+CommonUtil.pad(date.minute.toString())+" "+CommonUtil.pad(date.month.toString())+"/"+CommonUtil.pad(date.day.toString());
  }
  
  void cancelOrder(int orderSn){
    _progressDialog.show();
    var params = {'orderSn':orderSn.toString()};
    DioManager.getInstance().post(Url.EXCHANGE_ORDER_CANCEL, params, (data){
      Future.delayed(Duration(milliseconds: 500),(){
        _progressDialog.hide();
        initData();
      });
    }, (error){
      _progressDialog.hide();
      CommonUtil.showToast(error);
    });
  }

  Widget _renderHistoryItem(int index){
    TextStyle tvValue = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
    TextStyle tvTitle = TextStyle(color: Colours.dark_textTitle,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din',fontWeight: FontWeight.w500);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(186),
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
                        Text(historyList[index].direction == 0?'buy'.tr():'sale'.tr(),style: TextStyle(fontSize: ScreenUtil().setSp(28),color: historyList[index].direction == 0?Config.greenColor:Config.redColor,),),
                        Padding(
                          child:Text(historyList[index].symbol,style: TextStyle(fontSize: ScreenUtil().setSp(28),color: Colours.dark_text_gray,),),
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                        ),
                        Text(renderTimeHistory(historyList[index].updateTime),style: TextStyle(fontSize: ScreenUtil().setSp(28),color: Color(0xFF5B606E),fontFamily: 'Din'),),
                      ],
                    ),
                    historyList[index].status == 3?Text('order_canceling'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24)),):
                    GestureDetector(
                      onTap: (){
                          cancelOrder(historyList[index].orderSn);
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(84),
                        height: ScreenUtil().setHeight(40),
                        decoration: BoxDecoration(
                            color: Color(0xff17d7ab).withOpacity(0.2),
                            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))
                        ),
                        child: Center(
                          child: Text('order_cancel'.tr(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: ScreenUtil().setSp(24)),),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                    )
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
                          Text('price'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].price.toString(),style: tvTitle,),
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
                          Text('count'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].amount.toString(),style: tvTitle,),
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex:3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('order_hasfinsih'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].tradedAmount.toString(),style: tvTitle,),
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                          )
                        ],
                      ),
                    )
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

  Widget _buildHistroy(){
    return Container(
      color: Colours.dark_bg_gray,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('order_curret'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize:ScreenUtil().setSp(32)),),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: ScreenUtil().setWidth(100),
                    child:Text('more'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24)),),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return OrderListPage(symbol: curretItem.symbol,);
                    }));
                  },
                  behavior: HitTestBehavior.opaque,
                )
              ],
            ),
            width: double.infinity,
            height: ScreenUtil().setHeight(100),
          ),
          Divider(
            color: Colours.dark_text_gray.withOpacity(0.05),
          ),
          //EmptyView()
          historyList.length == 0 ? EmptyView():
            ListView.builder(
              padding: EdgeInsets.only(top: 0),
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              itemCount: historyList.length, //数据的数量
              itemBuilder: (BuildContext context,int index){
              return  _renderHistoryItem(index);
              },
            )
        ],
      )
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
    return Consumer<SymbolState>(
      builder: (context,symbolState,child){
        return Material(
            child: Scaffold(
              backgroundColor: Colours.dark_bg_gray,
              appBar: AppBar(
                elevation: 0.0,
                centerTitle: false,
                title: Row(
                  children: <Widget>[
                    Text(fromName+'/'+toName,style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(40),fontFamily: 'Din'),),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                      child: SmallRiseFullButton(isRise: CommonUtil.isRise(curretItem.chg),text: CommonUtil.isRiseString(curretItem.chg)+CommonUtil.formatNum(curretItem.chg*100, 2)+'%'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: ImageIcon(
                        AssetImage('res/ic_kline.png'),
                        size:ScreenUtil().setWidth(30)
                    ),
                    onPressed: () {
                      Global.curretSymbol = name;
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return KLinePage();
                      }));
                    },
                  ),
                ],
              ),
              drawer: new Drawer(
                  child:  TradingDrawer()
              ),
              body: SingleChildScrollView(
                  child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            color: Colours.dark_bg_gray,
                            height: ScreenUtil().setHeight(730),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                _buildLeft(),
                                _buildTrans(),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(20),
                            color: Colours.dark_bg_color,
                          ),
                          _buildHistroy()
                        ],
                      ),
                    ),
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    behavior: HitTestBehavior.opaque,
                  )
              ),
            )
        );
      },
    );

  }
}

class LeftClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width*0.92, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RightClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    var path = Path()
      ..moveTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..lineTo(size.width*0.08, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}