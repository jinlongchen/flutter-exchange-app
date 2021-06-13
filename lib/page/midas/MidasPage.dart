import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/page/midas/MidasDetailPage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class MidasPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MidasPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData(){
    DioManager.getInstance().post(Url.MIDAS_LIST, null, (data){

    }, (error){
      CommonUtil.showToast(error);
    });
  }
  
  Widget _buildArea(String icon,String name,String intro){
    return Card(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),top: ScreenUtil().setHeight(40)),
        color: Color(0xff3e6cdc),
        clipBehavior: Clip.antiAlias,
        child: Container(
        width: ScreenUtil().setWidth(686),
        height: ScreenUtil().setHeight(178),
        decoration: BoxDecoration(
            color: Color(0xff3e6cdc),
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32),vertical: ScreenUtil().setHeight(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(icon,width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(38),),
                Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  child: Text(name,style: TextStyle(fontFamily: 'Din',color: Colors.white,fontSize: ScreenUtil().setSp(32)),),
                ),
              ],
            ),
            Padding(
              child:Text(intro,style: TextStyle(fontFamily: 'Din',color: Colors.white.withOpacity(0.8),fontSize: ScreenUtil().setSp(28))),
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            )
          ],
        ),
      )
    );
  }

  TextStyle tvValue = TextStyle(color: Colors.white,fontFamily: 'Din',fontSize: ScreenUtil().setSp(28));
  TextStyle tvTitle = TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontFamily: 'Din',fontSize: ScreenUtil().setSp(22));

  Widget _buildItem(){
    return Card(
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(460),
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32),vertical: ScreenUtil().setHeight(40)),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32)),
        color: Color(0xff202d49),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(116),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name',style: TextStyle(color: Colors.white,fontFamily: 'Din',fontSize: ScreenUtil().setSp(36)),),
                  Text('未开始',style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(24)),)
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('申购进度',style: tvTitle,),
                  Text('0%',style: tvValue,)
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(12),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(12),
                    decoration: BoxDecoration(
                        color: Color(0xff8d8d94).withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(300),
                    height: ScreenUtil().setHeight(12),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff4a68ff),
                            Color(0xff00ffb3),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(38)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('申购开始时间',style: tvTitle,),
                  Text('2020-10-23 13:11:00',style: tvValue,)
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(42)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('发行价格',style: tvTitle,),
                  Text('1 DFS = 0.2 USDT',style: tvValue,)
                ],
              ),
            ),
            Padding(
              child: SizedBox(
                width: ScreenUtil().setWidth(686),
                height: ScreenUtil().setHeight(60),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.all(0.0),
                  child: Text('参与项目',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return MidasDetailPage();
                    }));
                  },
                  elevation: 4.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(0),bottom: ScreenUtil().setHeight(1)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colours.dark_bg_gray),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(500),
                        padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("res/midas_bg.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    IconButton(
                                      icon: ImageIcon(
                                        AssetImage('res/return.png'),
                                        size: ScreenUtil().setWidth(32),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('HiBi Midas Pad',style: TextStyle(color: Colors.white,fontFamily: 'Din',fontSize: ScreenUtil().setSp(40)),),
                                          Text('数字资产发售平台',style: TextStyle(color: Colors.white,fontFamily: 'Din',fontSize: ScreenUtil().setSp(40))),
                                          Text('持有BBT即可参与申购，获取空投！',style: TextStyle(color: Colors.white.withOpacity(0.6),fontFamily: 'Din',fontSize: ScreenUtil().setSp(22)))
                                        ],
                                      ),
                                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
                                    ),
                                    Image.asset('res/midas_main.png',width: ScreenUtil().setWidth(356),height: ScreenUtil().setHeight(228),)
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: CommonUtil.isDark(context)?Colours.dark_bg_gray:Colours.bg_gray,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(ScreenUtil().setWidth(40)),topRight: Radius.circular(ScreenUtil().setWidth(40)))
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: ScreenUtil().setHeight(120),
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('当前优质资产',style: TextStyle(color: CommonUtil.getTitleColor(context),fontSize: ScreenUtil().setSp(32),fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Divider(
                                height: ScreenUtil().setHeight(2),
                              ),
                              _buildItem(),
                              Card(
                                child: Container(
                                  width: double.infinity,
                                  height: ScreenUtil().setHeight(200),
                                  color: Color(0xff202d49),
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32),bottom: ScreenUtil().setWidth(62)),
                                  child: Center(
                                    child: Text('敬请期待...',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                                  ),
                                ),
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
