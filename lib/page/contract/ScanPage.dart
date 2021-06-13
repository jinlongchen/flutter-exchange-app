import 'package:hibi/event/event_bus.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AboutPageState();
  }
}

class _AboutPageState extends State<ScanPage> {
  bool isOk = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*QrReaderViewController _controller;

  void onScan(String v, List<Offset> offsets) {
    _controller.stopCamera();
    eventBus.fire(new RefreshCode(v));
    Navigator.of(context).pop();
   *//* Future.delayed(Duration(seconds: 3),(){
      //Navigator.of(context).pop(v);
    });*//*
  }*/


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar:  AppBar(
          leading: AppBarReturn(),
        ),
        body:Container(
            width: double.infinity,
            height: double.infinity,
            /*child:QrReaderView(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                callback: (container) {
                  this._controller = container;
                  _controller.startCamera(onScan);
                }
            )*/
        )
    );
  }

}
