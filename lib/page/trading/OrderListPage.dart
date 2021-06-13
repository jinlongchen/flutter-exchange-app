import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/order_list_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:hibi/widget/EmptyView.dart';
import 'package:hibi/widget/MyUnderlineTabIndicator.dart';
import 'package:hibi/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatefulWidget {
  final String symbol;

  const OrderListPage({Key key, this.symbol}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<OrderListPage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  final List<String> pages = ['order_curret'.tr(),'order_history'.tr()];
  int curretIndex = 0;

  List<OrderListDataData> historyList = [];

  String _symbol = '';
  bool showSort = false;
  int sortType = 0;

  ScrollController _controller = new ScrollController();
  int _page = 1;
  bool hasMore = true;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    if(!CommonUtil.isEmpty(widget.symbol)){
      setState(() {
        _symbol = widget.symbol;
      });
    }
    _tabController = TabController(length: pages.length, vsync: this);
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && hasMore) {
        _onLoading();
      }
    });
    initData();
  }

  void sortShowSymbolDialog(){
    List<SymbolListData> datas = Provider.of<SymbolState>(context, listen: false).symbol;
    List<Widget> list = [];
    for(SymbolListData item in datas){
      list.add(SimpleDialogOption(
        child: new Text(item.coinSymbol),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            _symbol = item.symbol;
          });
        },
      ));
    }
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor:Colours.dark_bg_gray,
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }


  void initData(){
    setState(() {
      _page = 1;
      historyList = [];
      hasMore = true;
      isLoad = false;
    });
    var params = {'symbol':_symbol,'pageNo':1,'pageSize':20,};
    if(sortType != 0){
      params['direction'] = sortType == 1?'BUY':'SELL';
    }
    String url = '';
    if(curretIndex == 0){
      url = Url.ORDER_LIST_USER;
    }else{
      url = Url.ORDER_LIST_HISTORY_USER;
    }
    DioManager.getInstance().post(url, params, (data){
      OrderListEntity orderListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        historyList =  orderListEntity.data.data;
        if(orderListEntity.data.total <= 1 * 20){
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
    var params = {'symbol':_symbol,'pageNo':_page,'pageSize':20,};
    if(sortType != 0){
      params['direction'] = sortType == 1?'BUY':'SELL';
    }
    String url = '';
    if(curretIndex == 0){
      url = Url.ORDER_LIST_USER;
    }else{
      url = Url.ORDER_LIST_HISTORY_USER;
    }
    DioManager.getInstance().post(url, params, (data) async {
      OrderListEntity orderListEntity = JsonConvert.fromJsonAsT(data);
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
        eventBus.fire(new RefreshCurretSymbol());
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


  Widget _renderHistoryItem2(int index){
    TextStyle tvValue = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
    TextStyle tvTitle = TextStyle(color: Colours.dark_textTitle,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din',fontWeight: FontWeight.w500);

    String stuats = '';
    if(historyList[index].status == 0){
      stuats = 'order_wcj'.tr();
    }else if(historyList[index].status == 1){
      stuats = 'order_hasfinsih'.tr();
    }else if(historyList[index].status == 2){
      stuats = 'order_cancel_label'.tr();
    }
    String tradedPrice = '';
    try{
      if(historyList[index].turnover >0 && historyList[index].tradedAmount >0){
        num traded_price = historyList[index].turnover / historyList[index].tradedAmount;
        tradedPrice = traded_price.toStringAsFixed(4);
      }
    }catch(e){

    }
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(288),
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
                      ],
                    ),
                    Text(stuats,style: TextStyle(color: Color(0xFF9496A2),fontSize: ScreenUtil().setSp(24)),)
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
                          Text('time'.tr(),style: tvValue,),
                          Padding(
                            child: Text(renderTimeHistory(historyList[index].updateTime),style: tvTitle,),
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
                          Text('order_wtjg'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].price.toString(),style: tvTitle,),
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
                          Text('order_wtsl'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].amount.toString(),style: tvTitle,),
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                          )
                        ],
                      ),
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
                          Text('order_cjze'.tr(),style: tvValue,),
                          Padding(
                            child: Text(historyList[index].turnover.toString(),style: tvTitle,),
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
                          Text('order_cjjj'.tr(),style: tvValue,),
                          Padding(
                            child: Text(tradedPrice,style: tvTitle,),
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
                          Text('order_cjl'.tr(),style: tvValue,),
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


  Widget _renderStatusButton(int type,String text){
    if(sortType == type){
      return Container(
        width: ScreenUtil().setWidth(140),
        height: ScreenUtil().setHeight(48),
        margin:EdgeInsets.only(right: ScreenUtil().setWidth(20)),
        decoration: new BoxDecoration(
          border: new Border.all(color: Theme.of(context).accentColor, width: ScreenUtil().setWidth(2)),
          borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
        ),
        child: Center(
          child: Text(text,style: TextStyle(color:Theme.of(context).accentColor,fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),),
        ),
      );
    }else{
      return GestureDetector(
        child: Container(
          width: ScreenUtil().setWidth(140),
          height: ScreenUtil().setHeight(48),
          margin:EdgeInsets.only(right: ScreenUtil().setWidth(20)),
          decoration: new BoxDecoration(
            color: Color(0xFF202D49),
            borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
          ),
          child: Center(
            child: Text(text,style: TextStyle(color: Color(0xFF9496A2),fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),),
          ),
        ),
        onTap: (){
          setState(() {
            sortType = type;
          });
        },
        behavior: HitTestBehavior.opaque,
      );
    }
  }

  String getSymbolCoin(){
    if(!CommonUtil.isEmpty(_symbol)){
      return _symbol.split('_')[0];
    }
    return '';
  }

  ProgressDialog _progressDialog;
  Color borderColor = Color(0xFFE0E0E7).withOpacity(0.3);

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
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Scaffold(
                backgroundColor: Theme.of(context).canvasColor,
                appBar: AppBar(
                    elevation: 4.0,
                    leading: AppBarReturn(),
                    actions: <Widget>[
                      IconButton(
                        icon: ImageIcon(
                            AssetImage('res/icon_sort.png'),
                            size:ScreenUtil().setWidth(34)
                        ),
                        onPressed: () {
                          setState(() {
                            showSort = true;
                          });
                        },
                      ),
                    ],
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(48.0),
                        child: Container(
                          height: 48.0,
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            onTap: (e){
                              setState(() {
                                curretIndex = e;
                                initData();
                              });
                            },
                            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(32)),
                            labelColor: Color(0xFFE0E0E7),
                            unselectedLabelColor: Color(0xFFE0E0E7).withOpacity(0.3),
                            controller: _tabController,
                            isScrollable: true,
                            indicator: MyUnderlineTabIndicator(borderSide:  BorderSide(width: 2.0, color: Theme.of(context).accentColor)),
                            tabs: pages.map((String title) {
                              return Tab(
                                text: title,
                              );
                            }).toList(),
                          ),
                        )
                    )
                ),
                body:  historyList.length == 0?
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: EmptyView(),
                      ),
                    ):
                    SingleChildScrollView(
                      controller: _controller,
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        itemCount: historyList.length, //数据的数量
                        itemBuilder: (BuildContext context,int index){
                          return  curretIndex == 0 ?_renderHistoryItem(index):_renderHistoryItem2(index);
                        },
                      ),
                    )
            ),
            showSort?Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Color(0x90000000)),
              child: Column(
                children: <Widget>[
                  AppBar(
                    leading: AppBarReturn(),
                    actions: <Widget>[
                      IconButton(
                        icon: ImageIcon(
                            AssetImage('res/icon_sort.png'),
                            size:ScreenUtil().setWidth(34)
                        ),
                        onPressed: () {
                          setState(() {
                            showSort = false;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(540),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    decoration: BoxDecoration(
                        color: CommonUtil.isDark(context)?Colours.dark_bg_gray:Colours.bg_gray,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(ScreenUtil().setWidth(40)),bottomRight: Radius.circular(ScreenUtil().setWidth(40)))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(40)),
                          child:Text('symbol'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32)),)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                width: ScreenUtil().setWidth(316),
                                height: ScreenUtil().setHeight(68),
                                decoration: new BoxDecoration(
                                  border: new Border.all(color: borderColor, width: ScreenUtil().setWidth(2)),
                                  borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
                                ),
                                child: Center(
                                  child: Text(CommonUtil.isEmpty(_symbol)?'coin_type'.tr():getSymbolCoin(),style: TextStyle(color: CommonUtil.isEmpty(_symbol)?Color(0xFF5B606E):Colours.dark_text_gray,fontFamily: 'Din',fontSize: ScreenUtil().setSp(28)),),
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                sortShowSymbolDialog();
                              },
                            ),
                            Text('/',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontWeight: FontWeight.bold),),
                            Container(
                              width: ScreenUtil().setWidth(316),
                              height: ScreenUtil().setHeight(68),
                              decoration: new BoxDecoration(
                                border: new Border.all(color: borderColor, width: ScreenUtil().setWidth(2)),
                                borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
                              ),
                              child: Center(
                                child: Text('USDT',style: TextStyle(color: Colours.dark_text_gray,fontFamily: 'Din',fontSize: ScreenUtil().setSp(28)),),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                            child:Text('status'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32)),)
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(32),bottom: ScreenUtil().setHeight(40)),
                          child: Row(
                            children: <Widget>[
                              _renderStatusButton(0,'all'.tr()),
                              _renderStatusButton(1,'buy'.tr()),
                              _renderStatusButton(2,'sale'.tr()),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colours.dark_text_gray.withOpacity(0.05),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  width: ScreenUtil().setWidth(324),
                                  height: ScreenUtil().setHeight(68),
                                  decoration: new BoxDecoration(
                                    color: Color(0xFF202D49),
                                    borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
                                  ),
                                  child: Center(
                                    child: Text('reset'.tr(),style: TextStyle(color:Color(0xFF9496A2),fontFamily: 'Din',fontSize: ScreenUtil().setSp(28)),),
                                  ),
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  setState(() {
                                    _symbol = '';
                                    sortType = 0;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  width: ScreenUtil().setWidth(324),
                                  height: ScreenUtil().setHeight(68),
                                  decoration: new BoxDecoration(
                                    color: Colours.dark_accent_color,
                                    borderRadius: new BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
                                  ),
                                  child: Center(
                                    child: Text('ok'.tr(),style: TextStyle(color:Colors.white,fontFamily: 'Din',fontSize: ScreenUtil().setSp(28)),),
                                  ),
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  setState(() {
                                    showSort = false;
                                  });
                                  initData();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      onTap: (){
                        setState(() {
                          showSort = false;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                    )
                  )
                ],
              ),
            ):Container(),
          ],
        ),
      )
    );
  }
}
