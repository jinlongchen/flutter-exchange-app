import 'dart:convert';
import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/banner_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sp_util/sp_util.dart';
import 'package:video_player/video_player.dart';



class LoadingPage extends StatefulWidget {
  @override
  _LoadingState createState() => new _LoadingState();
}

class _LoadingState extends State<LoadingPage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('res/loading.mp4')..initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        _controller.setVolume(0);
        _controller.play();
        countdown();
      });
    });
    //countdown();
    initUser();
    getThumbData();
    getHomeBanner();
    getNotice();
  }

  void getHomeBanner(){
    DioManager.getInstance().post(Url.HOME_BANNER, {"sysAdvertiseLocation":"0"}, (data){
      BannerEntity bannerEntity = JsonConvert.fromJsonAsT(data);
      Global.bannerList = bannerEntity.data;
    }, (error){
    });
  }

  void getNotice(){
    DioManager.getInstance().get(Url.ZDEX_HELP, null, (data){
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      String content = dataMap['data'];
      Map<String, dynamic> dataMap2 = json.decode(content);
      List<dynamic> items = dataMap2['articles'];
      Global.notices = items;
    }, (error){

    });
  }


  void getThumbData() {
    DioManager.getInstance().post(Url.THUMB, null, (data){
      SymbolListEntity symbolListEntity = JsonConvert.fromJsonAsT(data);
      List<String> collects = SpUtil.getStringList("collect",defValue: []);
      for(SymbolListData item in symbolListEntity.data){
        for(String str in collects){
          if(item.symbol == str){
            item.isCollect = true;
          }
        }
      }
      Provider.of<SymbolState>(context, listen: false).updateSymbolList(symbolListEntity.data);
    }, (error){
    });
  }

  void countdown(){
    Timer timer = new Timer(new Duration(milliseconds: 4800), () {
      if(CommonUtil.isEmpty(SpUtil.getString(Config.isFirst))){
        Navigator.of(context).pushReplacementNamed("/Welcome");
      }else{
        Navigator.of(context).pushReplacementNamed("/Main");
      }
    });
  }

  Future<void> initUser() async {
    DioManager.getInstance().post(Url.USER_INFO, null, (data2){
      UserEntity userEntity = JsonConvert.fromJsonAsT(data2);
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(userEntity.data);
    }, (error){
      Provider.of<UserInfoState>(context, listen: false).updateUserInfo(null);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff020610),
      child: _controller.value.initialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Container(),
    );
    return  Container(
      width: double.infinity,
      height: ScreenUtil.screenHeightDp,
      child: Image.asset('res/loading.gif',width: double.infinity,height: double.infinity,fit: BoxFit.fill,),
    );
  }
}
