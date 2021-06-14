import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/model/TransObject.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/page/trading/KLinePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibration/vibration.dart';
import 'package:easy_localization/easy_localization.dart';

import 'RiseFullButton.dart';

class PriceItem extends StatefulWidget{
  final TransObject itemObject;
  final Function onSetPrice;
  final num offset;
  final bool isRise;

  const PriceItem({Key key, this.itemObject, this.onSetPrice, this.offset, this.isRise}) : super(key: key);
  @override
  _State createState() => new _State();

}

class _State extends State<PriceItem> with TickerProviderStateMixin {

  bool isUpdate = false;

  num offset = 0;

  Animation _animation;
  AnimationController _controller ;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    setState(() {
      offset = widget.offset;
    });
  }

  @override
  void didUpdateWidget(PriceItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      offset = widget.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    TransObject item = widget.itemObject;
    return Expanded(
        child: InkWell(
          child: Stack(
            alignment:Alignment.centerRight,
            children: <Widget>[
              AnimatedContainer(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                width: ScreenUtil().setWidth(314) * offset,
                height: double.infinity,
                duration: Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                color: widget.isRise?Config.redColor.withOpacity(0.3):Config.greenColor.withOpacity(0.3),
              ),
              Padding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child:Text(item.price.toString(),style: TextStyle(color: widget.isRise?Config.redColor:Config.greenColor,fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                    ),
                    Expanded(
                      child: Text(item.volumn.toString(),style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),textAlign: TextAlign.right,),
                    )
                  ],
                ),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
              )
            ],
          ),
          onTap: (){
            widget.onSetPrice(item.price.toString());
          },
        )
    );
  }
}
