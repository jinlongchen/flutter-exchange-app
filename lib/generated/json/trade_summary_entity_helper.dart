import 'package:hibi/model/trade_summary_entity.dart';

tradeSummaryEntityFromJson(TradeSummaryEntity data, Map<String, dynamic> json) {
	if (json['symbol'] != null) {
		data.symbol = json['symbol']?.toString();
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
	if (json['zone'] != null) {
		data.zone = json['zone']?.toInt();
	}
	if (json['time'] != null) {
		data.time = json['time']?.toInt();
	}
	return data;
}

Map<String, dynamic> tradeSummaryEntityToJson(TradeSummaryEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['symbol'] = entity.symbol;
	data['open'] = entity.open;
	data['high'] = entity.high;
	data['low'] = entity.low;
	data['close'] = entity.close;
	data['chg'] = entity.chg;
	data['change'] = entity.change;
	data['volume'] = entity.volume;
	data['turnover'] = entity.turnover;
	data['zone'] = entity.zone;
	data['time'] = entity.time;
	return data;
}