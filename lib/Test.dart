import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class Test extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<Test> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: Center(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                  child: Text('Home',style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: ScreenUtil().setSp(50) ),),
                )
              ],
            )
        )
    );
  }
}
