import 'package:hibi/generated/json/base/json_convert_content.dart';

class TradeSummaryEntity with JsonConvert<TradeSummaryEntity> {
	String symbol;
	double open;
	double high;
	double low;
	double close;
	double chg;
	double change;
	double volume;
	double turnover;
	int zone;
	int time;
}
