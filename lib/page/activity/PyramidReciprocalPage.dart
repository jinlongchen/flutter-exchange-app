import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/order_list_entity.dart';
import 'package:hibi/model/pocs_list_entity.dart';
import 'package:hibi/model/pyramid_reciprocal_entity.dart';
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

class PyramidReciprocalPage extends StatefulWidget {

  const PyramidReciprocalPage({Key key}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<PyramidReciprocalPage> with SingleTickerProviderStateMixin {


  List<PyramidReciprocalDataData> historyList = [];

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
    DioManager.getInstance().post(Url.PYRAMID_RECIPROCAL, params, (data){
      PyramidReciprocalEntity pocsListEntity = JsonConvert.fromJsonAsT(data);
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
    DioManager.getInstance().post(Url.PYRAMID_RECIPROCAL, params, (data) async {
      PyramidReciprocalEntity pocsListEntity = JsonConvert.fromJsonAsT(data);
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

  Widget _renderItem(int index){
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
                child: Text(historyList[index].userName,style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(historyList[index].createTime,style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),),
                  )
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  ProgressDialog _progressDialog;
  Color borderColor = Color(0xFFE0E0E7).withOpacity(0.3);

  TextStyle tvTitle = TextStyle(color: Colors.white.withOpacity(0.23),fontSize: ScreenUtil().setSp(24));

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
                    title: Text('最后存入排名'),
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32)),
                        child: Column(
                          children: [
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
                                        child: Text('时间',style: tvTitle,),
                                      )
                                  )
                                ],
                              ),
                            ),
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
                      )
                    )
            ),
          ],
        ),
      )
    );
  }
}
