import 'dart:io';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/page/user/LoginPage.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/widget/CustomNavigatorObserver.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';
import 'Config.dart';
import 'package:flutter/services.dart';

class DioManager {
  static DioManager _instance;

  static DioManager getInstance() {
    if (_instance == null) {
      _instance = DioManager();
    }
    return _instance;
  }

  Dio dio = new Dio();
  DioManager() {
    dio.options.baseUrl = Url.BASE_URL;
    dio.options.connectTimeout = 500000;
    dio.options.receiveTimeout = 300000;
    dio.interceptors
        .add(LogInterceptor(responseBody: Config.isDebug)); //是否开启请求日志
  }

  //get请求
  get(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, 'get', params, errorCallBack);
  }

  //post请求
  post(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, "post", params, errorCallBack);
  }

  //post请求
  patch(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, "patch", params, errorCallBack);
  }

  put(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, "put", params, errorCallBack);
  }

  delete(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, "delete", params, errorCallBack);
  }

  String getLanguage(String languageCode) {
    switch (languageCode) {
      case "zh":
        return "zh-cn";
      case "en":
        return "en-us";
      case "vi":
        return "vi-vn";
      case "zh-TW":
        return "zh-tw";
    }
  }

  _requstHttp(String url, Function successCallBack,
      [String? method, params, Function? errorCallBack, bool? isBanner]) async {
    String laguageCode = "CN";
    if (params != null) {
      params['lang'] = laguageCode;
    } else {
      params = {'lang': laguageCode};
    }

    Response response;
    try {
      if (method == 'get') {
        if (params != null) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == 'post') {
        dio.options.headers = {
          "Content-Type": 'application/json',
          "x-auth-token": SpUtil.getString(Config.token),
          "EXP-LANG": laguageCode,
          "EXP-DEVICE": Platform.isAndroid ? "ANDROID" : "iOS",
        };

        if (Config.isDebug) {
          print('请求url: ' + url);
          print('请求头: ' + dio.options.headers.toString());
          if (params != null) {
            print('请求参数: ' + params.toString());
          }
        }

        params = FormData.fromMap(params);

        if (params != null) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      } else if (method == 'put') {
        if (params != null) {
          response = await dio.put(url, data: params);
        } else {
          response = await dio.put(url);
        }
      } else if (method == 'delete') {
        if (params != null) {
          response = await dio.delete(url, data: params);
        } else {
          response = await dio.delete(url);
        }
      } else if (method == 'patch') {
        if (params != null) {
          response = await dio.patch(url, data: params);
        } else {
          response = await dio.patch(url);
        }
      }
    } on DioError catch (error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      // 请求超时
      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
      }
      // 一般服务器错误
      else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
      }

      // debug模式才打印
      if (Config.isDebug) {
        print('请求异常: ' + error.toString());
        print('请求异常url: ' + url);
        print('请求头: ' + dio.options.headers.toString());
      }
      _error(errorCallBack, "网络连接错误，请稍后重试");
      return '';
    }

    // debug模式打印相关数据
    if (Config.isDebug) {
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }

    String dataStr = json.encode(response.data);
    try {
      Map<String, dynamic> dataMap = json.decode(dataStr);
      if (dataMap['code'] == 0) {
        successCallBack(response.data);
      } else if (dataMap['code'] != 0) {
        _error(errorCallBack, dataMap['message']);
      }
    } catch (error) {
      Map<String, dynamic> dataMap = json.decode(response.data);
      if (dataMap['code'] == 0) {
        successCallBack(response.data);
      } else if (dataMap['code'] == 4000) {
        SpUtil.putString(Config.token, "");
        Provider.of<UserInfoState>(Global.navigatorKey.currentContext,
                listen: false)
            .updateUserInfo(null);
        if (url == Url.USER_INFO) {
          _error(errorCallBack, dataMap['message']);
        } else {
          _error(errorCallBack, dataMap['message']);
          Global.navigatorKey.currentState
              .push(MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        }
      }
    }
  }

  _error(Function errorCallBack, error) {
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }
}

class ResultCode {
  //正常返回是1
  static const SUCCESS = 1;

  //异常返回是0
  static const ERROR = 0;

  /// When opening  url timeout, it occurs.
  static const CONNECT_TIMEOUT = -1;

  ///It occurs when receiving timeout.
  static const RECEIVE_TIMEOUT = -2;

  /// When the server response, but with a incorrect status, such as 404, 503...
  static const RESPONSE = -3;

  /// When the request is cancelled, dio will throw a error with this type.
  static const CANCEL = -4;

  /// read the DioError.error if it is not null.
  static const DEFAULT = -5;
}
