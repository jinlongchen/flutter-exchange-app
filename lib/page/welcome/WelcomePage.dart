import 'package:hibi/common/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sp_util/sp_util.dart';

class WelcomePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<WelcomePage> {

  List<String> pics = [
    "res/splash_1.png",
    "res/splash_2.png",
    "res/splash_3.png",
  ];

  List<String> texts = [
    "融合理财超市，总有一款适合你",
    "全新撮合引擎，华尔街微秒级体验",
    "全新UI，为交易者打造",
  ];

  @override
  void initState() {
    super.initState();
    SpUtil.putString(Config.isFirst, "1");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    ScreenUtil.init(context, width: 750, height: 1624);
    return Material(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child:  Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(1052),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(pics[index]),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(172),left: ScreenUtil().setWidth(52)),
                          child: Text('HiBi 1.0',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(46),fontFamily: 'Din'),),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(152)),
                        child:Text(texts[index],style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(36),fontWeight: FontWeight.bold),)
                      ),
                      index == 2?Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(108)),
                        width: ScreenUtil().setWidth(318),
                        height: ScreenUtil().setHeight(76),
                        child: RaisedButton(
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          color: Theme.of(context).accentColor,
                          child: Text('立即体验'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("/Main");
                          },
                        ),
                      ):Container()
                    ],
                  )
              );
            },
            itemCount: 3,
            autoplay:false,
            pagination:  SwiperPagination(
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(86)),
                builder:  DotSwiperPaginationBuilder(color: Colors.grey, activeColor: Colors.white)),
          ),
        )
    );
  }
}
