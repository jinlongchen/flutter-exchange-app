import 'package:hibi/model/login_entity.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:flutter/material.dart';

class UserInfoState with  ChangeNotifier{

  UserData _userInfoModel;
  bool _isLogin;


  get isLogin => _userInfoModel == null?false:true;
  get userInfoModel => _userInfoModel;

  // 接口方法
  void updateUserInfo(UserData userInfoModel) {
    _userInfoModel = userInfoModel;
    notifyListeners();
  }


  bool isLoginStatus(){
    return _isLogin;
  }
}