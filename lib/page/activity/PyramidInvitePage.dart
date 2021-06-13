import 'package:hibi/page/mine/InvitePage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class PyramidInvitePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<PyramidInvitePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildTop(){
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(532),
      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("res/pyramid_invite_bg.png"),
          fit: BoxFit.fill,
        )
      ),
      child: Container(
          width: double.infinity,
          child: Column(
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
              Expanded(
                  child: Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(48),bottom: ScreenUtil().setHeight(40)),
                              child:Image.asset('res/pyramid_invite_text.png',width: ScreenUtil().setWidth(326),height: ScreenUtil().setHeight(100),),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return InvitePage();
                                }));
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(156),
                                height: ScreenUtil().setHeight(60),
                                decoration: BoxDecoration(
                                    color: Color(0xff0093ec),
                                    borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))
                                ),
                                child: Center(
                                  child: Text('去邀请',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),),
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                            )
                          ],
                        ),
                        Image.asset('res/activity_bg.png',width: ScreenUtil().setWidth(300),height: ScreenUtil().setWidth(300),)
                      ],
                    ),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(10),bottom: ScreenUtil().setHeight(20)),
                  )
              ),
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Material(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colours.dark_bg_gray),
          child: Stack(
            children: <Widget>[
              _buildTop(),
              Positioned(
                top: ScreenUtil().setHeight(500),
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                          child:Image.asset('res/pyramid_invite_content.png',width: ScreenUtil().setWidth(670),height: ScreenUtil().setHeight(220),)
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                            child:Text('规则说明',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(32)),)
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                            child:Text('1、邀请好友需参与双星计划；\n2、享受直接邀请好友双星收益的50%奖励，可享受间接好友双星收益10%的奖励；\n3、活动如有调整，以 HiBi 平台更新为准，最终解释权归HiBi所有。',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(28)),)
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colours.dark_bg_gray,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(ScreenUtil().setWidth(40)),topRight: Radius.circular(ScreenUtil().setWidth(40)))
                    ),
                  ),
                )
              )
            ],
          )
        )
    );
  }
}
