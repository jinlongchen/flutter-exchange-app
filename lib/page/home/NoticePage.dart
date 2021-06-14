/*
 * @Description: file
 * @Autor: dingyiming
 * @Date: 2021-06-14 07:38:06
 * @LastEditors: dingyiming
 * @LastEditTime: 2021-06-14 09:52:49
 */
import 'dart:convert';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../WebPage.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<NoticePage> {
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    DioManager.getInstance().get(
        "https://www.hibi.co/api/uc/v1/zendesk/sign?url=/api/v2/help_center/articles.json?label_names=landingpage&page=1&per_page=999&sort_by=created_at&sort_order=desc&nsukey=NbeSC6003lZenHJS%2BLMeDmjOEzPLTH04wITV2awEvQ4pBqQ5EqFDAFm94gDcLXL%2FiqOmiubWwIF980%2B3e%2FwklLOmooPiRgoxrVXevx3W1nAg1AiMquBBkjxMM3XHw2mRdoicdQuGz5Lk8O%2BkQWZL1fCj4hdr5DxlVXESTKcGHrnXZRQ0TfZGWfgHCIeq1Bo2y133eoOy5VsyV5SsbOus8g%3D%3D",
        null, (data) {
      String dataStr = json.encode(data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      String content = dataMap['data'];
      Map<String, dynamic> dataMap2 = json.decode(content);
      List<dynamic> items = dataMap2['articles'];
      setState(() {
        list = items;
      });
    }, (error) {});
  }

  Widget getItem(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WebPage(
            url: list[index]['html_url'],
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        height: ScreenUtil().setHeight(110),
        child: Container(
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: Colours.dark_text_gray.withOpacity(0.05)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                list[index]['title'],
                style: TextStyle(fontSize: ScreenUtil().setSp(28)),
              ),
              Text('')
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        centerTitle: false,
        title: Text('notice'.tr()),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return getItem(index);
        },
      ),
    ));
  }
}
