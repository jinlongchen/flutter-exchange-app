import 'package:hibi/page/user/RegisterEmailPage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';

import 'LoginPage.dart';
import 'RegisterPhonePage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<RegisterPage> {
  SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;
  bool _isLoggedIn = true;

  void _toggleLoginStatus() {
    setState(() {
      _isLoggedIn = !_isLoggedIn;
    });
  }

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
          title: null,
          elevation: 0.0,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(32)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'register_haveaccount'.tr(),
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Colours.dark_text_gray,
                              ),
                            ),
                            TextSpan(
                              text: 'login'.tr(),
                              style: TextStyle(
                                color: Color(0xFF1A72CE),
                                fontSize: ScreenUtil().setSp(32),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      },
                    )
                  ],
                )
              )
            )
          ],
        ),
        body: GestureDetector(
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                      child: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 800),
                        reverse: !_isLoggedIn,
                        transitionBuilder: (
                            Widget child,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            ) {
                          return SharedAxisTransition(
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: _transitionType,
                          );
                        },
                        child: _isLoggedIn ? RegisterPhonePage(onChange: (v){
                          _toggleLoginStatus();
                        },) : RegisterEmailPage(onChange: (v){
                          _toggleLoginStatus();
                        },),
                      ),
                    )
                ),
              ],
            ),
          ),
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          behavior: HitTestBehavior.opaque,
        )
    );
  }
}
