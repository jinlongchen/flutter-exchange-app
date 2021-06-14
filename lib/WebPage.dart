/*
 * @Description: file
 * @Autor: dingyiming
 * @Date: 2021-06-14 07:53:33
 * @LastEditors: dingyiming
 * @LastEditTime: 2021-06-14 09:44:10
 */
import 'dart:async';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;

  const WebPage({Key? key, required this.url}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<WebPage> with TickerProviderStateMixin {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true; // 设置状态

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBarReturn(),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                var url = request.url;
                setState(() {
                  isLoading = true; // 开始访问页面，更新状态
                });
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                setState(() {
                  isLoading = false; // 页面加载完成，更新状态
                });
              },
            ),
            isLoading
                ? Container(
                    color: Colours.dark_bg_gray,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
