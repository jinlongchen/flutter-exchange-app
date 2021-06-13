import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyView extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<EmptyView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(470),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('res/empty.png',width: ScreenUtil().setWidth(146),height: ScreenUtil().setHeight(88),),
          Text('empty'.tr(),style: TextStyle(color: Color(0xFF5B606E),fontSize: ScreenUtil().setSp(24)),)
        ],
      ),
    );
  }
}
