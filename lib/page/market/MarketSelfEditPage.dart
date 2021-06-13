import 'package:hibi/common/Config.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:drag_list/drag_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';

class MarketSelfEditPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MarketSelfEditPage> {

  List<String> listCollect = [];
  List<bool> listCollectCheck = [];
  bool isAll = false;

  @override
  void initState() {
    super.initState();
    _getCollectList();
  }

  void _getCollectList(){
    List<String> list = SpUtil.getStringList("collect",defValue: []);
    for(int i=0;i<list.length;i++){
      listCollectCheck.add(false);
    }
    setState(() {
      listCollect = list;
    });

  }

  void delete(){
    List<String> deleteList = [];
    for(int i=0;i<listCollect.length;i++){
      if(listCollectCheck[i]){
        deleteList.add(listCollect[i]);
      }
    }
    if(deleteList.length == 0){
      return;
    }
    for(String item in deleteList){
      listCollect.remove(item);
      Provider.of<SymbolState>(context, listen: false).collectSymbol(item);
    }
    setState(() {

    });
    SpUtil.putStringList('collect', listCollect);
  }

  Future<void> save() async {
    SpUtil.putStringList('collect', listCollect);
  }

  void clearAddBool(bool isCheck){
    if(isCheck){
      for(int i=0;i< listCollectCheck.length;i++){
        listCollectCheck[i] = true;
      }
    }else{
      for(int i=0;i< listCollectCheck.length;i++){
        listCollectCheck[i] = false;
      }
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        title: Text('zixuan'.tr()),
        centerTitle: false,
      ),
      body: SafeArea(
          child:Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(110)),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(88),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: Colours.dark_text_gray.withOpacity(0.05)))
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(92)),
                            child: Text('code_p'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24)),),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: ScreenUtil().setWidth(32)),
                            child: Text('scroll'.tr(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24))),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: DragList<String>(
                        items: listCollect,
                        itemExtent: ScreenUtil().setHeight(110),
                        onItemReorder: (from, to) { //修改数据源
                          var temp=listCollect[from];
                          listCollect[from]=listCollect[to];
                          listCollect[to]=temp;
                          setState(() {

                          });
                          save();
                        },
                        itemBuilder: (context, item, handle) {
                          return Container(
                            height:  ScreenUtil().setHeight(110),
                            child: Row(children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: ScreenUtil().setWidth(92),
                                      height: double.infinity,
                                      child: Center(
                                        child: Checkbox(
                                          value: listCollectCheck[item.itemIndex],
                                          onChanged: (bool value) {
                                            setState(() {
                                              listCollectCheck[item.itemIndex] = !listCollectCheck[item.itemIndex];
                                            });
                                          },
                                        ),
                                      )
                                  ),
                                  Text(item.value,style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
                                ],
                              ),
                              handle,
                            ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                          );
                        },
                        handleBuilder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(right: ScreenUtil().setHeight(32)),
                            child: Container(
                              child: ImageIcon(
                                AssetImage('res/drag.png'),
                                size:ScreenUtil().setWidth(33),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(98),
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 0.5, color: Color(0xff222631)))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: ScreenUtil().setWidth(92),
                              height: double.infinity,
                              child: Center(
                                child: Checkbox(
                                  value: isAll,
                                  onChanged: (bool value) {
                                    clearAddBool(value);
                                    setState(() {
                                      isAll = !isAll;
                                    });
                                  },
                                ),
                              )
                          ),
                          Text('all'.tr()),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          delete();
                        },
                        child: Container(
                            padding: EdgeInsets.only(right: ScreenUtil().setWidth(32)),
                            child: Row(
                              children: <Widget>[
                                Text('delete'.tr(),style: TextStyle(color: Config.textGrey),),
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
