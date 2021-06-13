import 'package:animations/animations.dart';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/assets_record_list_entity.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AssetsRecordPage extends StatefulWidget {
  final List<MoneyListDataData> symbolList;

  const AssetsRecordPage({Key key, this.symbolList}) : super(key: key);
  @override
  _State createState() => new _State();
}

class _State extends State<AssetsRecordPage> {

  List<AssetsRecordListDataData> list = [];

  String symbol = "";
  String type = "";

  int _page = 1;
  bool hasMore = true;
  bool isLoad = false;

  ScrollController _controller = new ScrollController();


  @override
  void initState() {
    super.initState();
    _onRefresh();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && hasMore) {
        _onLoading();
      }
    });
  }


  Future _onRefresh() async  {
    setState(() {
      _page = 1;
    });
    var params ={'pageNo':1,'pageSize':20,'symbol':symbol,'type':type,};
    DioManager.getInstance().post(Url.MONEY_DEPOSIT, params, (data) async {
      AssetsRecordListEntity assetsRecordListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        list =  assetsRecordListEntity.data.data;
        if(assetsRecordListEntity.data.total <= 1 * 20){
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
    var params ={'pageNo':_page,'pageSize':20,'symbol':symbol,'type':type};
    DioManager.getInstance().get(Url.MONEY_DEPOSIT, params, (data) async {
      AssetsRecordListEntity assetsRecordListEntity = JsonConvert.fromJsonAsT(data);
      setState(() {
        list.addAll(assetsRecordListEntity.data.data);
        if(assetsRecordListEntity.data.total <= _page * 20){
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

  void sortSymbol(){
    List<Widget> list = [];
    for(MoneyListDataData item in widget.symbolList){
      list.add(SimpleDialogOption(
        child: new Text(item.coin.name),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            symbol = item.coin.name;
            _onRefresh();
          });
        },
      ));
    }
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor: Colours.dark_bg_gray,
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }

  void sortHistory(){
    List<Widget> list = [];
    Global.flowtypes.forEach((key, value) {
      list.add(SimpleDialogOption(
        child: new Text(value),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            type = key;
            _onRefresh();
          });
        },
      ));
    });
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(transitionDuration:Duration(milliseconds: 500)),
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor: Colours.dark_bg_gray,
            title: new Text('please_select'.tr()),
            children: list
        );
      },
    );
  }


  TextStyle tvValue = TextStyle(color: Colours.dark_textTitle.withOpacity(0.6),fontSize: ScreenUtil().setSp(24));
  TextStyle tvTitle = TextStyle(color: Colours.dark_textTitle,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din',fontWeight: FontWeight.w500);

  Widget getItem(int index){
    AssetsRecordListDataData item = list[index];
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(210),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Global.flowtypes[item.type.toString()],style: tvTitle,),
                Text(item.symbol,style: tvTitle,)
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('count'.tr(),style: tvValue,),
                      Padding(
                        child: Text(item.amount.toString(),style: tvTitle,),
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
                      Text('status'.tr(),style: tvValue,),
                      Padding(
                        child: Text('success'.tr(),style: tvTitle,),
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
                      Text('time'.tr(),style: tvValue,),
                      Padding(
                        child: Text(item.createTime == null?'':item.createTime.toString(),style: tvTitle,),
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Color(0xff1B1F2C),
            height: ScreenUtil().setHeight(2),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        title: Text('财务记录'),
        centerTitle: false,
        leading: AppBarReturn(),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(CommonUtil.isEmpty(symbol)?'币种':symbol),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      sortSymbol();
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(CommonUtil.isEmpty(type)?'类型':Global.flowtypes[type.toString()]),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                    onTap: (){
                      sortHistory();
                    },
                  )
                )
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              controller: _controller,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return getItem(index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
