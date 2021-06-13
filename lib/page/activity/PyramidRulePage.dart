import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class PyramidRulePage extends StatefulWidget {

  final String text;

  const PyramidRulePage({Key key, this.text}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<PyramidRulePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40)),
          child: Text(widget.text,style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.92),fontFamily: 'Din',fontSize: ScreenUtil().setSp(28)),),
        ),
      ),
    );
  }
}
