import 'package:hibi/model/treaty_list_entity.dart';

treatyListEntityFromJson(TreatyListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<TreatyListData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new TreatyListData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> treatyListEntityToJson(TreatyListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

treatyListDataFromJson(TreatyListData data, Map<String, dynamic> json) {
	if (json['symbol'] != null) {
		data.symbol = json['symbol']?.toString();
	}
	if (json['symbolCode'] != null) {
		data.symbolCode = json['symbolCode']?.toString();
	}
	if (json['symbolIndex'] != null) {
		data.symbolIndex = json['symbolIndex']?.toString();
	}
	if (json['settleCurrency'] != null) {
		data.settleCurrency = json['settleCurrency']?.toString();
	}
	if (json['contractValue'] != null) {
		data.contractValue = json['contractValue']?.toDouble();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
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
	if (json['volume'] != null) {
		data.volume = json['volume']?.toDouble();
	}
	if (json['turnover'] != null) {
		data.turnover = json['turnover']?.toDouble();
	}
	if (json['time'] != null) {
		data.time = json['time']?.toDouble();
	}
	if (json['capitalRate'] != null) {
		data.capitalRate = json['capitalRate']?.toDouble();
	}
	if (json['currCapitalRate'] != null) {
		data.currCapitalRate = json['currCapitalRate']?.toDouble();
	}
	return data;
}

Map<String, dynamic> treatyListDataToJson(TreatyListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['symbol'] = entity.symbol;
	data['symbolCode'] = entity.symbolCode;
	data['symbolIndex'] = entity.symbolIndex;
	data['settleCurrency'] = entity.settleCurrency;
	data['contractValue'] = entity.contractValue;
	data['status'] = entity.status;
	data['priceCNY'] = entity.priceCNY;
	data['open'] = entity.open;
	data['high'] = entity.high;
	data['low'] = entity.low;
	data['close'] = entity.close;
	data['chg'] = entity.chg;
	data['volume'] = entity.volume;
	data['turnover'] = entity.turnover;
	data['time'] = entity.time;
	data['capitalRate'] = entity.capitalRate;
	data['currCapitalRate'] = entity.currCapitalRate;
	return data;
}