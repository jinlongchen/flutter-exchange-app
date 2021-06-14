import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarReturn extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: ImageIcon(
            AssetImage('res/return.png'),
            size: ScreenUtil().setWidth(32),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}