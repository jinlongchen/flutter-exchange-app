import 'package:hibi/model/symbol_list_entity.dart';

symbolListEntityFromJson(SymbolListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<SymbolListData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new SymbolListData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> symbolListEntityToJson(SymbolListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

symbolListDataFromJson(SymbolListData data, Map<String, dynamic> json) {
	if (json['symbol'] != null) {
		data.symbol = json['symbol']?.toString();
	}
	if (json['baseSymbol'] != null) {
		data.baseSymbol = json['baseSymbol']?.toString();
	}
	if (json['baseScale'] != null) {
		data.baseScale = json['baseScale']?.toInt();
	}
	if (json['coinSymbol'] != null) {
		data.coinSymbol = json['coinSymbol']?.toString();
	}
	if (json['coinScale'] != null) {
		data.coinScale = json['coinScale']?.toInt();
	}
	if (json['fee'] != null) {
		data.fee = json['fee']?.toDouble();
	}
	if (json['digit'] != null) {
		data.digit = json['digit'];
	}
	if (json['infolink'] != null) {
		data.infolink = json['infolink']?.toString();
	}
	if (json['enableMarketBuy'] != null) {
		data.enableMarketBuy = json['enableMarketBuy']?.toInt();
	}
	if (json['enableMarketSell'] != null) {
		data.enableMarketSell = json['enableMarketSell']?.toInt();
	}
	if (json['exchangeable'] != null) {
		data.exchangeable = json['exchangeable']?.toInt();
	}
	if (json['visible'] != null) {
		data.visible = json['visible']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['startTime'] != null) {
		data.startTime = json['startTime']?.toString();
	}
	if (json['endTime'] != null) {
		data.endTime = json['endTime']?.toString();
	}
	if (json['zone'] != null) {
		data.zone = json['zone']?.toInt();
	}
	if (json['priceCNY'] != null) {
		data.priceCNY = json['priceCNY']?.toDouble();
	}
	if (json['open'] != null) {
		data.open = json['open']?.toDouble();
	}
	if (json['high'] != null) {
		data.high = json['high']?.toDouble();
	}
	if (json['low'] != null) {
		data.low = json['low']?.toDouble();
	}
	if (json['close'] != null) {
		data.close = json['close']?.toDouble();
	}
	if (json['chg'] != null) {
		data.chg = json['chg']?.toDouble();
	}
	if (json['change'] != null) {
		data.change = json['change']?.toDouble();
	}
	if (json['volume'] != null) {
		data.volume = json['volume']?.toDouble();
	}
	if (json['turnover'] != null) {
		data.turnover = json['turnover']?.toDouble();
	}
	if (json['trend'] != null) {
		data.trend = json['trend']?.map((v) => v?.toDouble())?.toList()?.cast<double>();
	}
	if (json['isCollect'] != null) {
		data.isCollect = json['isCollect'];
	}
	return data;
}

Map<String, dynamic> symbolListDataToJson(SymbolListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['symbol'] = entity.symbol;
	data['baseSymbol'] = entity.baseSymbol;
	data['baseScale'] = entity.baseScale;
	data['coinSymbol'] = entity.coinSymbol;
	data['coinScale'] = entity.coinScale;
	data['fee'] = entity.fee;
	data['digit'] = entity.digit;
	data['infolink'] = entity.infolink;
	data['enableMarketBuy'] = entity.enableMarketBuy;
	data['enableMarketSell'] = entity.enableMarketSell;
	data['exchangeable'] = entity.exchangeable;
	data['visible'] = entity.visible;
	data['status'] = entity.status;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['zone'] = entity.zone;
	data['priceCNY'] = entity.priceCNY;
	data['open'] = entity.open;
	data['high'] = entity.high;
	data['low'] = entity.low;
	data['close'] = entity.close;
	data['chg'] = entity.chg;
	data['change'] = entity.change;
	data['volume'] = entity.volume;
	data['turnover'] = entity.turnover;
	data['trend'] = entity.trend;
	data['isCollect'] = entity.isCollect;
	return data;
}