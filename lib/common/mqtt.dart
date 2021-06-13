//示例 https://github.com/shamblett/mqtt_client/blob/master/example/iot_core.dart
import 'dart:async';
import 'dart:async' show Future;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/market_trade_entity.dart';
import 'package:hibi/model/trade_summary_entity.dart';
import 'package:hibi/page/kline/chart/chart_model.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

bool debug = false;

String _server;

String _user;

String _password;


///超时时间 s
int _keepAlive = 30;

///是否连接
bool _connected = false;


///重连间隔 初始5s 每次重连递增 5s
int _recontectDelay = 5;
String platform = () {
  // 平台字符串
  if (Platform.isAndroid)
    return 'ANDROID';
  else if (Platform.isIOS) return 'IOS';
  return '';
}();
String _clientId = '${platform}flutter${Random().nextInt(1000000)}';


MqttServerClient _client;



// MqttServerClient _client =  MqttServerClient.withPort(_serverTest, _clientId, _port);
class MqttUtils {

  static MqttUtils _instance;
  List<String> topics = [];

  static MqttUtils getInstance() {
    if (_instance == null) {
      _instance = MqttUtils();
    }
    return _instance;
  }

  Future<int> init(
      {String host, String port, String user, String password}) async {
    _user = user;
    _password = password;
    _server = host;
    print("MqttUtils:"+host+":"+port);
    print("MqttUtils:"+_clientId);
    //_client = MqttServerClient(host, _clientId);
    _client = MqttServerClient("ws://"+host+"/mqtt", _clientId);

    _client.port = num.tryParse(port);
     _client.useWebSocket = true;
     _client.websocketProtocols = ['mqtt'];
    _client.logging(on: debug);
    _client.keepAlivePeriod = _keepAlive;
    /// 安全认证
    /*_client.secure = false;
    _client.onBadCertificate = (dynamic a) => true;

    final SecurityContext context = SecurityContext.defaultContext;

     try {
       var certificate = (await rootBundle.load("res/hibi.co.pem")).buffer.asInt8List();
       print(certificate.toString());
       context.setTrustedCertificatesBytes(certificate);
     } on Exception catch (e) {
       //出现异常 证书配置错误
       print("SecurityContext set  error : " + e.toString());
       return -1;
     }
    _client.securityContext = context;*/

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(
        _clientId)
        .authenticateAs(user,password)
        .keepAliveFor(_keepAlive)
        .withWillTopic("willTopic")
        .withWillMessage('willMessage')
        .withWillQos(MqttQos.atMostOnce);

    print(' Mosquitto client connecting....');

    _client.connectionMessage = connMess;

    _client.setProtocolV311();

    ///连接成功回调
    _client.onConnected = onConnected;

    ///连接断开回调
    _client.onDisconnected = onDisconnected;

    ///订阅成功回调
    _client.onSubscribed = onSubscribed;

    _client.pongCallback = ping;
    _client.autoReconnect = true;
    _client.onAutoReconnect = onAutoReconnect;

    return 0;
  }

  /// 用户登录之后初始化  0 初始化成功  否则失败
  Future<int> connect() async {
    try {
      await _client.connect(_user, _password);
    } on Exception catch (e) {
      print('MqttUtils::client exception - $e');
      _client.disconnect();
    }

    // 检查连接的状态
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      _connected = true;
    } else {
      _client.disconnect();
      return -1;
    }

    // 监听订阅消息的响应
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      String topic = c[0].topic;
      final String dataJson =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      //print(dataJson);
      if(topic == '/topic/market/trade_summary'){
        TradeSummaryEntity tradeSummaryEntity = JsonConvert.fromJsonAsT(json.decode(dataJson));
        eventBus.fire(new SocketTradeSummary(tradeSummaryEntity));
      }else if(topic.contains("/topic/MARKET_DEPTH_")){
        eventBus.fire(new SocketDepth(dataJson));
      }else if(topic.contains("/topic/market/trade/")){
        Map<String,dynamic> dataMap = json.decode(dataJson);
        MarketTradeData item = new MarketTradeData();
        item.amount = double.tryParse(dataMap['amount'].toString());
        item.price = double.tryParse(dataMap['price'].toString());
        item.direction = int.tryParse(dataMap['direction'].toString());
        item.time = int.tryParse(dataMap['time'].toString());
        eventBus.fire(new SocketTrade(item));
      }else if(topic.contains("/topic/market/kline/")){
        Map<String,dynamic> dataMap = json.decode(dataJson);
        ChartModel chartModel = new ChartModel(dataMap['time'], double.tryParse(dataMap['open'].toString()), double.tryParse(dataMap['close'].toString()), double.tryParse(dataMap['high'].toString()), double.tryParse(dataMap['low'].toString()), double.tryParse(dataMap['volume'].toString()));
        eventBus.fire(new SocketKLine(chartModel));
      }
    });
    return 0;
  }


  /// 订阅消息
  bool subscribe(String topic,
      {MqttQos qosLevel = MqttQos.atMostOnce, Function callBack}) {

    if(topic.contains("/topic/MARKET_DEPTH_")){
      bool needClear = true;
      if(topics.length != 0){
        for(String topic2 in topics){
          if(topic2 == topic){
            needClear = false;
          }
        }
      }
      if(needClear){
        clearAllDepth();
      }else{
        return true;
      }
    }

    if(topic.contains("/topic/market/trade/")){
      bool needClear = true;
      if(topics.length != 0){
        for(String topic2 in topics){
          if(topic2 == topic){
            needClear = false;
          }
        }
      }
      if(needClear){
        clearAllTrade();
      }else{
        return true;
      }
    }

    if(topic.contains("/topic/market/kline/")){
      bool needClear = true;
      if(topics.length != 0){
        for(String topic2 in topics){
          if(topic2 == topic){
            needClear = false;
          }
        }
      }
      if(needClear){
        clearAllKline();
      }else{
        return true;
      }
    }

    print('MqttUtils::subscribe topic = $topic ');
    _client.subscribe(topic, qosLevel);
    topics.add(topic);
    return true;
  }

  ///取消订阅
  bool unsubscribe(String topic) {
    print('MqttUtils::Unsubscribing' + topic);
    _client.unsubscribe(topic);
    topics.remove(topic);
    return true;
  }

  void clearAllDepth(){
    if(topics.length != 0){
      for(String topic in topics){
        if(topic.contains("/topic/MARKET_DEPTH_")){
          _client.unsubscribe(topic);
          topics.remove(topic);
          return;
        }
      }
    }
  }

  void clearAllTrade(){
    if(topics.length != 0){
      for(String topic in topics){
        if(topic.contains("/topic/market/trade/")){
          _client.unsubscribe(topic);
          topics.remove(topic);
          return;
        }
      }
    }
  }

  void clearAllKline(){
    if(topics.length != 0){
      for(String topic in topics){
        if(topic.contains("/topic/market/kline/")){
          _client.unsubscribe(topic);
          topics.remove(topic);
          return;
        }
      }
    }
  }

  ///中断连接
  void disConnect() {
    print('MqttUtils::Disconnecting');
    _client.disconnect();
    _connected = false;
  }

  void dreConnect() {
    print('MqttUtils::Reconnect');
    _client.resubscribe();
    _connected = false;
  }

  ///连接成功的回调
  void onConnected() {
    print('MqttUtils::Connected Successful');
    if(topics.length != 0){
      eventBus.fire(new ReConnectSokcet(topics));
    }
  }

  ///订阅成功回调
  void onSubscribed(String topic) {
    print('MqttUtils::Subscription confirmed for topic $topic');
  }

//断开连接的回调
  void onDisconnected() async {
    print('MqttUtils::OnDisconnected client callback - Client disconnection');
    //_connected = false;

    /*if (_canReConnected()) {
     await Future.delayed(Duration(seconds: _recontectDelay));
     _recontectDelay += _recontectTimeAdd;
     print("mqtt start reConntect");
     MqttUtils.getInstance().connect(MQTTTopic.device_id, MQTTTopic.device_uid);
   }*/
  }

  void onAutoReconnect(){
    print("重新连接");
  }


  void ping() {
  }



}


