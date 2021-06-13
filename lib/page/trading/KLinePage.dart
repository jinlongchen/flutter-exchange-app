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
import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/MarketItem.dart';
import 'package:hibi/model/TransObject.dart';
import 'package:hibi/model/TransObjectList.dart';
import 'package:hibi/model/market_trade_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/page/kline/chart/chart_model.dart';
import 'package:hibi/page/kline/chart/kline_view.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orientation/orientation.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:web_socket_channel/io.dart';
import 'package:easy_localization/easy_localization.dart';

class KLinePage extends StatefulWidget {


  @override
  _State createState() => new _State();
}

class _State extends State<KLinePage> with TickerProviderStateMixin {
  final List<String> pages = ['deepth'.tr(),'market'.tr()];

  int curretTimeIndex = 0;
  int curretTimeSubIndex = 0;
  List<String> _timeIndex = [
    "15分钟",
    "1小时",
    "4小时",
    "1天",
    "更多",
  ];
  List<ChartModel> dataList = List();
  bool _isShowMenu = false;
  bool _isShowSubview = false;
  bool _isShowMore = false;
  bool showLoading = false;


  int _viewTypeIndex = 0;
  int _subviewTypeIndex = 0;
  ///  k线实时请求，防止刷新之后返回到最右边
  String _currentDataType;

  SymbolListData curretItem;
  String itemPriceVND = '';

  int curretIndex = 0;
  int commodityReserveCount = 0;

  //k线推送
  StreamSubscription  _sub;
  //depth
  StreamSubscription  _sub2;
  //成交
  StreamSubscription  _sub3;



  TabController _tabController2;

  List<MarketTradeData>  listMarket = [];

  @override
  void initState() {
    super.initState();
    _tabController2 = TabController(length: 2,vsync: this,initialIndex: 0);
    setState(() {
      curretItem = Provider.of<SymbolState>(context, listen: false).getCurretSymbol();
    });
    getKDataList();
    _sub = eventBus.on<SocketKLine>().listen((event) {
      if(dataList.last.timestamp == event.data.timestamp){
        dataList.last.openPrice = event.data.openPrice;
        dataList.last.closePrice = event.data.closePrice;
        dataList.last.maxPrice = event.data.maxPrice;
        dataList.last.minPrice = event.data.minPrice;
        dataList.last.volume = double.tryParse(event.data.volume.toString());
      }else{
        dataList.add(event.data);
      }
      setState(() {
      });
    });
    _sub2 = eventBus.on<SocketDepth>().listen((event) {
      _renderDepth(event.data,true);
    });
    _sub3 = eventBus.on<SocketTrade>().listen((event) {
      setState(() {
        listMarket.insert(0, event.data);
      });
    });

    initDepth();
    initTrade();
  }


  @override
  void dispose() {
    _sub.cancel();
    _sub2.cancel();
    _sub3.cancel();
    super.dispose();
  }

  void initTrade(){
    var params = {'symbol':curretItem.symbol,'size':20};
    DioManager.getInstance().post(Url.MARKET_TRADE, params, (data){
      MarketTradeEntity marketTradeEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        listMarket = marketTradeEntity.data;
        listMarket.sort((left,right)=>right.time.compareTo(left.time));
      });
      MqttUtils.getInstance().subscribe("/topic/market/trade/"+curretItem.symbol);
    }, (error){
      CommonUtil.showToast(error);
    });
  }


  void initDepth(){
    var params = {'symbol':curretItem.symbol};
    DioManager.getInstance().post(Url.MARKET_DEPTH, params, (data){
      _renderDepth(json.encode(data),false);
      MqttUtils.getInstance().subscribe("/topic/MARKET_DEPTH_"+curretItem.symbol);
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
    for(int i=0;i<asks.length;i++){
      TransObject transObject = new TransObject();
      transObject.price = asks[i][0];
      transObject.volumn = asks[i][1];
      listAskss.add(transObject);
    }
    for(int i=0;i<bids.length;i++){
      TransObject transObject = new TransObject();
      transObject.price = bids[i][0];
      transObject.volumn = bids[i][1];
      listBidss.add(transObject);
    }
    setState(() {
      listAsks = listAskss;
      listBids = listBidss;
    });
  }


  int getTimeFromType(int index,int subIndex){
    DateTime now = DateTime.now();
    switch(index){
      case 0:
        return now.subtract(Duration(days: 18)).millisecondsSinceEpoch;
        break;
      case 1:
        return now.subtract(Duration(days: 60)).millisecondsSinceEpoch;
        break;
      case 2:
        return now.subtract(Duration(days: 120)).millisecondsSinceEpoch;
        break;
      case 3:
        return now.subtract(Duration(days: 120)).millisecondsSinceEpoch;
        break;
      case 4:
        switch(subIndex){
          case 0:
            return now.subtract(Duration(days: 2)).millisecondsSinceEpoch;
            break;
          case 1:
            return now.subtract(Duration(days: 4)).millisecondsSinceEpoch;
            break;
          case 2:
            return now.subtract(Duration(days: 30)).millisecondsSinceEpoch;
            break;
          case 3:
            return now.subtract(Duration(days: 365)).millisecondsSinceEpoch;
            break;
          case 4:
            return now.subtract(Duration(days: 365 * 4)).millisecondsSinceEpoch;
            break;
        }
        break;
    }
  }

  String getTypeFromType(int index,int subIndex){
    switch(index){
      case 0:
        return '15min';
        break;
      case 1:
        return '1hour';
        break;
      case 2:
        return '4hour';
        break;
      case 3:
        return '1day';
        break;
      case 4:
        switch(subIndex){
          case 0:
            return '1min';
            break;
          case 1:
            return '5min';
            break;
          case 2:
            return '30min';
            break;
          case 3:
            return '1week';
            break;
          case 4:
            return '1mon';
            break;
        }
        break;
    }
  }

  startKLlineSocket(){
    String klinetopic = "/topic/market/kline/"+curretItem.symbol+"_"+getTypeFromType(curretTimeIndex,curretTimeSubIndex);
    MqttUtils.getInstance().subscribe(klinetopic);
  }

  /// kline request  请求网路数据
  Future getKDataList() async {
    setState(() {
      showLoading = true;
    });

    var params = {
      'symbol':Global.curretSymbol,
      'period':getTypeFromType(curretTimeIndex,curretTimeSubIndex),
      'from':getTimeFromType(curretTimeIndex,curretTimeSubIndex).toString(),
      'to':new DateTime.now().millisecondsSinceEpoch.toString()
    };
    DioManager.getInstance().post(Url.KDATA, params, (data){
      Map<String, dynamic> dataMap = json.decode(json.encode(data));
      List dataMap2 = dataMap['data'];
      dataList = getKlineDataList(dataMap2);
      _currentDataType = getTypeFromType(curretTimeIndex,curretTimeSubIndex) + "btcusdt";
      showLoading = false;
      setState(() {

      });
      startKLlineSocket();
    }, (error){
      showLoading = false;
      CommonUtil.showToast(error);
    });
  }

  // k线返回数据模型
  List<ChartModel> getKlineDataList(List data) {
    List<ChartModel> kDataList = List();
    for (int i = 0; i < data.length; i++) {
      int timestamp = num.tryParse(data[i][0].toString());
      double openPrice = double.tryParse(data[i][1].toString());
      double maxPrice = double.tryParse(data[i][2].toString());
      double minPrice = double.tryParse(data[i][3].toString());
      double closePrice = double.tryParse(data[i][4].toString());
      double volume = double.tryParse(data[i][5].toString());
      if (volume > 0) {
        kDataList.add(ChartModel(timestamp, openPrice, closePrice, maxPrice, minPrice, volume));
      }
    }
    return kDataList;
  }

  String renderCount(num count){
    String allstr = count.toString();
    List<String> allstrs = allstr.split('.');
    if(allstrs.length > 1){
      if(allstrs[1].length < commodityReserveCount){
        return count.toString();
      }else{
        return count.toStringAsFixed(commodityReserveCount);
      }
    }else{
      return count.toString();
    }
  }

  Widget _buildTitleView(){
    return (
        Consumer<SymbolState>(
            builder: (context,symbolState,child){
              return (Container(
                color: Theme.of(context).canvasColor,
                height: ScreenUtil().setHeight(160),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:2,
                      child: Column(
                        children: <Widget>[
                          Text(curretItem.close.toString(),style: TextStyle(color: CommonUtil.isRise(curretItem.change)?Config.greenColor:Config.redColor,fontSize: ScreenUtil().setSp(44),fontFamily: 'Din'),),
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text:'≈'+CommonUtil.calcCny(curretItem.close, curretItem.priceCNY)+' CNY  ',style: TextStyle(color: Color(0xFFD7DCED).withOpacity(0.6),fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),),
                                  TextSpan(
                                    text: CommonUtil.isRiseString(curretItem.chg)+CommonUtil.formatNum(curretItem.chg*100, 2)+'%',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(26),
                                      fontFamily: 'Din',
                                      color: CommonUtil.isRise(curretItem.chg)?Config.greenColor:Config.redColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('    H',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                              Text(curretItem.high.toString(),style: TextStyle(color: Color(0xfffafafa),fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('    L',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                                Text(curretItem.low.toString(),style: TextStyle(color: Color(0xfffafafa),fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),)
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('24H',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                              Text(CommonUtil.parseVolume(curretItem.volume),style: TextStyle(color: Color(0xfffafafa),fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
            }
        )
    );
  }

  String getTitle(String name){
    return name.replaceAll('_', '/');
  }

  void viewType(int type) {
    switch (type) {
      case 0:
        _viewTypeIndex = 0;
        break;
      case 1:
        _viewTypeIndex = 1;
        break;
      case 2:
        _viewTypeIndex = 2;
        break;
    }
  }

  void subviewType(int type) {
    switch (type) {
      case 0:
        _subviewTypeIndex = 0;
        break;
      case 1:
        _subviewTypeIndex = 1;
        break;
      case 2:
        _subviewTypeIndex = 2;
        break;
    }
  }


  Widget _buildSubViewDialog(){
    if(!_isShowMenu){
      return Container();
    }
    Color text = Colors.white54;
    return Container(
      color: Colours.dark_bg_gray,
      height: ScreenUtil().setHeight(50),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "kline_subview".tr(),
            style: TextStyle(color: text),
          ),
          SizedBox(
            width: 20,
          ),
          Text("|", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Text(
              "MACD",
              style: TextStyle(color: text),
            ),
            onTap: () {
              setState(() {
                setState(() {
                  _isShowSubview = true;
                  subviewType(0);
                });
              });
            },
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Text(
              "KDJ",
              style: TextStyle(color: text),
            ),
            onTap: () {
              setState(() {
                _isShowSubview = true;
                subviewType(1);
              });
            },
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Text(
              "RSI",
              style: TextStyle(color: text),
            ),
            onTap: () {
              setState(() {
                _isShowSubview = true;
                subviewType(2);
              });
            },
          ),
         /* IconButton(
            iconSize: 16,
            icon: _isShowSubview
                ? Icon(Icons.visibility, color: Colors.grey)
                : Icon(Icons.visibility_off,
                color: Colors.grey),
            onPressed: () {
              setState(() {
                if (_isShowSubview) {
                  _isShowSubview = false;
                }
              });
            },
          )*/
        ],
      ),
    );
  }

  Widget _buildTabBarItem(int index){
    return Expanded(
      child: GestureDetector(
        child: Container(
          child: Column(
            children: <Widget>[
              Text(_timeIndex[index],style: TextStyle(color: index ==curretTimeIndex ? Colors.white : Colors.white54),),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                color: index ==curretTimeIndex ?Config.accentColor:Color(0xFF262626),
                width: ScreenUtil().setWidth(30),
                height: ScreenUtil().setHeight(2),
              )
            ],
          ),
        ),
        onTap: (){
          if(index == 4){
            setState(() {
              _isShowMore = !_isShowMore;
            });
          }else{
            setState(() {
              curretTimeIndex = index;
              _isShowMore = false;
              getKDataList();
            });
          }
        },
      )
    );
  }

  Widget _buildTabBar(){
    return Container(
      color: Colours.dark_bg_gray,
      child: Row(
        children: <Widget>[
          _buildTabBarItem(0),
          _buildTabBarItem(1),
          _buildTabBarItem(2),
          _buildTabBarItem(3),
          _buildTabBarItem(4),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if (_isShowMenu) {
                      _isShowMenu = false;
                    } else {
                      _isShowMenu = true;
                    }
                  });
                },
                child: Icon(
                  Icons.menu,
                  color: Colors.white54,
                  size: ScreenUtil().setWidth(34),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<String> subTitleList = ["1分钟","5分钟","30分钟","1周","1月"];

  Widget _buildSubTimeView(int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          _timeIndex[4] = subTitleList[index];
          curretTimeIndex = 4;
          curretTimeSubIndex = index;
          _isShowMore = false;
          getKDataList();
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
        child: Text(subTitleList[index],style: TextStyle(color: Colors.white54),),
      ),
    );
  }


  List<TransObject> listAsks = [];
  List<TransObject> listBids = [];

  Widget _buildPirceItem(TransObject item,int index){
    num allNum = 0;
    for(int j = 0;j<index+1;j++){
      allNum = allNum+listBids[j].volumn;
    }
    num baseNum = 0;
    for(int j = 0;j<listBids.length;j++){
      baseNum = baseNum+listBids[j].volumn;
    }
    num offset = allNum/baseNum;
    return( Container(
        child: GestureDetector(
          child: Stack(
            alignment:Alignment.centerRight,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                width: ScreenUtil().setWidth(300) * offset,
                height: ScreenUtil().setHeight(60),
                color: Config.greenColor.withOpacity(0.12),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child:Row(
                          children: <Widget>[
                            Text((index+1).toString(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                            Padding(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(34)),
                                child:Text(item.volumn.toString(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),)
                            )
                          ],
                        )
                    ),
                    Expanded(
                      child: Text(item.price.toString(),style: TextStyle(color: Config.greenColor,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),textAlign: TextAlign.right,),
                    )
                  ],
                ),
              )
            ],
          ),
          behavior: HitTestBehavior.opaque,
        )
    ));
  }

  Widget _buildPirceItemBids(TransObject item,int index){
    num allNum = 0;
    for(int j = 0;j<index+1;j++){
      allNum = allNum+listAsks[j].volumn;
    }
    num baseNum = 0;
    for(int j = 0;j<listAsks.length;j++){
      baseNum = baseNum+listAsks[j].volumn;
    }
    num offset = allNum/baseNum;
    return( Container(
        height: ScreenUtil().setHeight(60),
        child: GestureDetector(
          child: Stack(
            alignment:Alignment.centerLeft,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                width: ScreenUtil().setWidth(300) * offset,
                height: ScreenUtil().setHeight(60),
                color:Config.redColor.withOpacity(0.12),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(item.price.toString(),style: TextStyle(color: Config.redColor,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),textAlign: TextAlign.left,),
                    ),
                    Expanded(
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: ScreenUtil().setWidth(34)),
                                child:Text(item.volumn.toString(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),)
                            ),
                            Text((index+1).toString(),style: TextStyle(color:Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                          ],
                        )
                    ),

                  ],
                ),
              )
            ],
          ),
          behavior: HitTestBehavior.opaque,
        )
    ));
  }

  Widget _buildDeep(){
    if(curretItem == null){
      return Container();
    }
    List<Widget> transAsks = [];
    for(int i=0;i<listBids.length;i++){
      transAsks.add(_buildPirceItem(listBids[i],i));
    }
    List<Widget> transBids = [];
    for(int i=0;i<listAsks.length;i++){
      transBids.add(_buildPirceItemBids(listAsks[i],i));
    }

    TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(20),fontFamily: 'Din');
    return Container(
      color: Colours.dark_bg_gray,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('order_md'.tr(),style: tvTitle,),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                      child: Text('count'.tr()+'('+curretItem.coinSymbol+')',style: tvTitle,),
                    )
                  ],
                ),
                Text('price'.tr()+'('+curretItem.baseSymbol+')',style: tvTitle,),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: ScreenUtil().setWidth(2)),
                      child: Text('count'.tr()+'('+curretItem.coinSymbol+')',style: tvTitle,),
                    ),
                    Text('order_sell'.tr(),style: tvTitle,),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(120)),
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: transAsks
                    ),
                  )
              ),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(120)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: transBids
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMarket(){
    if(curretItem == null){
      return Container();
    }

    TextStyle tvTitle = TextStyle(color: Colours.dark_text.withOpacity(0.6),fontSize: ScreenUtil().setSp(20));


    List<Widget> transAsks = [];

    for(MarketTradeData item in listMarket){
      transAsks.add(Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child:Text(CommonUtil.formatTimeHHSSMM(DateTime.fromMillisecondsSinceEpoch(item.time)),style: TextStyle(color: Colours.dark_text.withOpacity(0.6),fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),),
            ),
            Expanded(
              child:Text(item.direction==0?'buy'.tr():'sale'.tr(),style: TextStyle(color: item.direction==0?Config.greenColor:Config.redColor,fontSize: ScreenUtil().setSp(24)),),
            ),
            Expanded(
              child:Text(item.price.toString(),style: TextStyle(color:item.direction==0?Config.greenColor:Config.redColor,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din' ),textAlign:TextAlign.center),
            ),
            Expanded(
              child:Text(item.amount.toString(),style:  TextStyle(color: Colours.dark_text,fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),textAlign: TextAlign.right,),
            )
          ],
        ),
      ),);
    }

    return Container(
      color: Colours.dark_bg_gray,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),bottom: ScreenUtil().setHeight(120)),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: <Widget>[
                Expanded(
                  child:Text('time'.tr(),style: tvTitle,),
                ),
                Expanded(
                  child:Text('type'.tr(),style: tvTitle,),
                ),
                Expanded(
                  child:Text('price'.tr()+'('+curretItem.baseSymbol+')',style: tvTitle,textAlign:TextAlign.center),
                ),
                Expanded(
                  child:Text('count'.tr()+'('+curretItem.coinSymbol+')',style: tvTitle,textAlign: TextAlign.right,),
                )
              ],
            ),
          ),
          Column(
            children: transAsks,
          )
        ],
      ),
    );
  }


  void addCollect(){
    List<String> collects = [];
    if(SpUtil.getStringList("collect") != null){
      List<String> collectsTemp = SpUtil.getStringList("collect");
      for(String item in collectsTemp){
        collects.add(item);
      }
      if(collects.contains(curretItem.symbol)){
        collects.remove(curretItem.symbol);
      }else{
        collects.add(curretItem.symbol);
      }
    }else{
      collects.add(curretItem.symbol);
    }
    SpUtil.putStringList("collect", collects);
    Provider.of<SymbolState>(context, listen: false).collectSymbol(curretItem.symbol);
    setState(() {
      curretItem = Provider.of<SymbolState>(context, listen: false).getCurretSymbol();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            leading: AppBarReturn(),
            title: Text(getTitle(Global.curretSymbol),style: TextStyle(color: Colors.white),),
            actions: <Widget>[
              IconButton(
                icon: ImageIcon(
                    AssetImage(curretItem.isCollect?'res/favorite.png':'res/favorite_p.png'),
                    size:ScreenUtil().setWidth(36),
                    color: curretItem.isCollect?Colours.dark_accent_color:Colours.dark_text_gray,
                ),
                onPressed: () {
                  addCollect();
                },
              ),
            ],
          ),
            body:SafeArea(
              child:  Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            _buildTitleView(),
                            _buildTabBar(),
                            _buildSubViewDialog(),
                            Container(
                              width: double.infinity,
                              height: ScreenUtil().setHeight(1),
                              color: Colors.black,
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                    height: 400.0,
                                    child: KlineView(
                                      showProgress: showLoading,
                                      dataList: dataList,
                                      currentDataType: _currentDataType,
                                      isShowSubview: true,
                                      viewType: _viewTypeIndex,
                                      subviewType: _subviewTypeIndex,
                                    )
                                ),
                                _isShowMore?
                                Container(
                                  width: double.infinity,
                                  height: ScreenUtil().setHeight(50),
                                  color: Colours.dark_bg_gray,
                                  child: Row(
                                    children: <Widget>[
                                      _buildSubTimeView(0),
                                      _buildSubTimeView(1),
                                      _buildSubTimeView(2),
                                      _buildSubTimeView(3),
                                      _buildSubTimeView(4)
                                    ],
                                  ),
                                ):Container()
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: ScreenUtil().setHeight(20),
                              color: Color(0xff1a1a1a),
                            ),
                            Container(
                              color: Colours.dark_bg_gray,
                              child: TabBar(
                                onTap: (e){
                                  setState(() {
                                    curretIndex = e;
                                  });
                                },
                                isScrollable: false,
                                controller: _tabController2,
                                tabs: pages.map((String title) {
                                  return Tab(
                                    text: title,
                                  );
                                }).toList(),
                              ),
                            ),
                          curretIndex == 0?
                              _buildDeep():_buildMarket()
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [BoxShadow(color: Color(0x630F0F10), offset: Offset(0.0, -4.0),    blurRadius: 24.0, spreadRadius: 0.0)],
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                          height: ScreenUtil().setHeight(120),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: ScreenUtil().setWidth(340),
                                height: ScreenUtil().setHeight(80),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.all(0.0),
                                  child: Text('buy'.tr(),style: TextStyle(color: Colors.white),),
                                  onPressed: () {
                                    eventBus.fire(new GotoTrade());
                                    Future.delayed(Duration(milliseconds: 120),(){
                                      eventBus.fire(new ChangeTradeType("buy"));
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  elevation: 4.0,
                                  color: Config.greenColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                                child:  SizedBox(
                                  width: ScreenUtil().setWidth(340),
                                  height: ScreenUtil().setHeight(80),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    child: Text('sale'.tr(),style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      eventBus.fire(new GotoTrade());
                                      Future.delayed(Duration(milliseconds: 120),(){
                                        eventBus.fire(new ChangeTradeType("sale"));
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    elevation: 4.0,
                                    color: Config.redColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            )
        ),
    );
  }
}
