import 'package:hibi/model/market_trade_entity.dart';

marketTradeEntityFromJson(MarketTradeEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<MarketTradeData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new MarketTradeData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> marketTradeEntityToJson(MarketTradeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

marketTradeDataFromJson(MarketTradeData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toDouble();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toDouble();
	}
	if (json['direction'] != null) {
		data.direction = json['direction']?.toInt();
	}
	if (json['time'] != null) {
		data.time = json['time']?.toInt();
	}
	return data;
}

Map<String, dynamic> marketTradeDataToJson(MarketTradeData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['price'] = entity.price;
	data['amount'] = entity.amount;
	data['direction'] = entity.direction;
	data['time'] = entity.time;
	return data;
}