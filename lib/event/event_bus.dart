import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/MarketItem.dart';
import 'package:hibi/model/TransObjectList.dart';
import 'package:hibi/model/market_trade_entity.dart';
import 'package:hibi/model/trade_summary_entity.dart';
import 'package:hibi/page/kline/chart/chart_model.dart';
import 'package:event_bus/event_bus.dart';
//Bus 初始化
EventBus eventBus = EventBus();

class UserRefreshEvent{
  UserRefreshEvent();
}

class SendSocketEvent{
  String msg;
  SendSocketEvent(this.msg);
}

class SocketKLine{
  ChartModel data;
  SocketKLine(this.data);
}

class RefreshUserInfo{

}

class SocketTradeSummary{
  TradeSummaryEntity data;
  SocketTradeSummary(this.data);
}

class RefreshCurretSymbol{

}

class SocketDepth{
  String data;
  SocketDepth(this.data);
}

class SocketTrade{
  MarketTradeData data;
  SocketTrade(this.data);
}

class RefreshAsstes{

}

class GotoTrade{

}

class ChangeTradeType{
  String type;
  ChangeTradeType(this.type);
}

class ReConnectSokcet{
  List<String> topics;
  ReConnectSokcet(this.topics);
}

class RefreshCode{
  String address;
  RefreshCode(this.address);
}

class RefreshPyramidSave{

}