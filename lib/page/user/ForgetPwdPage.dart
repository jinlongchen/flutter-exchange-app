import 'package:hibi/page/user/ForgetEmailPage.dart';
import 'package:hibi/page/user/RegisterEmailPage.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';

import 'ForgetPhonePage.dart';
import 'LoginPage.dart';
import 'RegisterPhonePage.dart';

class ForgetPwdPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<ForgetPwdPage> {
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
                        child: _isLoggedIn ? ForgetPhonePage(onChange: (v){
                          _toggleLoginStatus();
                        },) : ForgetEmailPage(onChange: (v){
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
