import 'package:hibi/common/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallRiseFullButton extends StatelessWidget{
  final String text;
  final bool isRise;

  const SmallRiseFullButton({Key key, this.text,this.isRise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String textFinal = '';
    List<String> abcs = text.split('.');
    if(abcs.length > 1){
      if(abcs[1].length == 2){
        textFinal = text.replaceAll('%', '0%');
      }else{
        textFinal = text;
      }
    }else{
      textFinal = text;
    }
    return Container(
      width: ScreenUtil().setWidth(80),
      height: ScreenUtil().setHeight(32),
      decoration: BoxDecoration(
          color: isRise?Config.greenColor.withOpacity(0.2):Config.redColorLess.withOpacity(0.2),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(4)),///圆角
      ),
      child: Center(child: Text(textFinal,style: TextStyle(color: isRise?Config.greenColor:Config.redColor,fontFamily: 'Din',fontSize: ScreenUtil().setSp(24)),),)
    );
  }

}