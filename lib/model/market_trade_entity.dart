import 'package:hibi/generated/json/base/json_convert_content.dart';

class MarketTradeEntity with JsonConvert<MarketTradeEntity> {
	int code;
	String message;
	List<MarketTradeData> data;
}

class MarketTradeData with JsonConvert<MarketTradeData> {
	int id;
	double price;
	double amount;
	int direction;
	int time;
}
