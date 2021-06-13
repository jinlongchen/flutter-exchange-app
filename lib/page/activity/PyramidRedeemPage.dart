import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/order_list_entity.dart';
import 'package:hibi/model/pocs_list_entity.dart';
import 'package:hibi/model/pyramid_redeem_entity.dart';
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

class PyramidRedeemPage extends StatefulWidget {

  const PyramidRedeemPage({Key key}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<PyramidRedeemPage> with SingleTickerProviderStateMixin {


  List<PyramidRedeemDataData> historyList = [];

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
    var params = {'pageNum':1,'pageSize':20,'label':'1'};
    DioManager.getInstance().post(Url.PYRAMID_REDEEM, params, (data){
      PyramidRedeemEntity pocsListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        historyList =  pocsListEntity.data.data;
        if(pocsListEntity.data.total <= 1 * 20){
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
    var params = {'pageNum':_page,'pageSize':20,'label':'1'};
    DioManager.getInstance().post(Url.PYRAMID_REDEEM, params, (data) async {
      PyramidRedeemEntity pocsListEntity = JsonConvert.fromJsonAsT(data);
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

  String renderTimeHistory(int timestamp){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return CommonUtil.pad(date.hour.toString())+":"+CommonUtil.pad(date.minute.toString())+" "+CommonUtil.pad(date.month.toString())+"/"+CommonUtil.pad(date.day.toString());
  }


  TextStyle tvTitlesub = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvNumber = TextStyle(color: Colours.dark_textTitle,fontFamily:'Din',fontSize: ScreenUtil().setSp(28));

  String _renderStatus(index){
    switch(historyList[index].status){
      case 0:
        return 'pocs_status0'.tr();
        break;
      case 1:
        return 'pocs_status1'.tr();
        break;
      case 2:
        return 'pocs_status2'.tr();
        break;
    }
  }

  Widget _renderItem(int index){
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(96),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(historyList[index].projectId,style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600),),
                        Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                            child:Text(historyList[index].redeemTime,style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontFamily:'Din',fontSize: ScreenUtil().setSp(28)),)
                        )
                      ],
                    ),
                    Text(historyList[index].buyNum.toString()+'个',style: TextStyle(color: Colors.white,fontFamily: 'Din',fontSize: ScreenUtil().setSp(30)),)
                  ],
                )
              )
          ),
          Divider()
        ],
      ),
    );
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
                    title: Text('赎回记录'),
                    centerTitle: false,
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
                          return  _renderItem(index);
                        },
                      ),
                    )
            ),
          ],
        ),
      )
    );
  }
}
