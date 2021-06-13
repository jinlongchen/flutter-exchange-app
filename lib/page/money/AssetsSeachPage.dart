import 'dart:convert';
import 'dart:io';
import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/model/money_list_entity.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetsSeachPage extends StatefulWidget {
  final String type;

  const AssetsSeachPage({Key key, this.type}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<AssetsSeachPage> {
  TextEditingController _searchQueryController = TextEditingController();
  List<MoneyListDataData> list = [];
  List<MoneyListDataData> listRefresh = [];


  @override
  void initState() {
    super.initState();
    _getCollectList();
  }

  void _getCollectList(){
    List<MoneyListDataData> assetResponsesList = Global.assetsList;
    List<MoneyListDataData> assetResponsesList2 = [];
    if(widget.type == 'draw'){
      for(MoneyListDataData item in assetResponsesList){
        if(item.coin.canWithdraw == 1){
          assetResponsesList2.add(item);
        }
      }
    }else if(widget.type == 'transfer'){
      for(MoneyListDataData item in assetResponsesList){
        if(item.coin.canTransfer == 1){
          assetResponsesList2.add(item);
        }
      }
    }else{
      for(MoneyListDataData item in assetResponsesList){
        if(item.coin.canRecharge == 1){
          assetResponsesList2.add(item);
        }
      }
    }
    setState(() {
      list = assetResponsesList2;
      listRefresh = assetResponsesList2;
    });
  }


  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white, width: 0.0),
        ),
        hintText: "coin_type".tr(),
      ),
      style: TextStyle(fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
  }

  void updateSearchQuery(String newQuery) {
    if(CommonUtil.isEmpty(newQuery)){
      setState(() {
        list = listRefresh;
      });
      return;
    }
    final suggestionList = list.where((p) => p.coin.name.contains(RegExp(newQuery, caseSensitive: false))).toList();
    setState(() {
      list = suggestionList;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }


  Widget getItem(int index){
    return InkWell(
      onTap: (){
        Navigator.of(context).pop(list[index]);
      },
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        height: ScreenUtil().setHeight(110),
        child: Container(
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1,color: Colours.dark_text_gray.withOpacity(0.05) ))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(list[index].coin.name,style: TextStyle(
                  fontSize: ScreenUtil().setSp(28)
              ),),
              Text('')
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: Scaffold(
          appBar: AppBar(
            leading: AppBarReturn(),
            centerTitle: false,
            title: Text('please_select'.tr()),
          ),
          body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return getItem(index);
            },
          ),
        )
    );
  }

}
