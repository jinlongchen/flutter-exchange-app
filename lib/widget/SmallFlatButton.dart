import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class SmallFlatButton extends StatefulWidget {

  final String text;
  final Function onClick;
  final bool canClick;

  const SmallFlatButton({Key key, this.text, this.onClick,this.canClick = true}) : super(key: key);
  @override
  _State createState() => new _State();
}

class _State extends State<SmallFlatButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.onClick != null && widget.canClick){
          widget.onClick();
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(152),
        height: ScreenUtil().setHeight(64),
        decoration: BoxDecoration(
            color: widget.canClick?Color(0xff17d7ab).withOpacity(0.2):Color(0xff202D49),
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))
        ),
        child: Center(
          child: Text(widget.text,style: TextStyle(color: widget.canClick?Theme.of(context).accentColor:Color(0xff5B606E),fontSize: ScreenUtil().setSp(28)),),
        ),
      ),
      behavior: HitTestBehavior.opaque,
    );
  }
}
