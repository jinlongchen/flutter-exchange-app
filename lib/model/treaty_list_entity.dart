import 'package:hibi/generated/json/base/json_convert_content.dart';

class TreatyListEntity with JsonConvert<TreatyListEntity> {
	int code;
	String message;
	List<TreatyListData> data;
}

class TreatyListData with JsonConvert<TreatyListData> {
	String symbol;
	String symbolCode;
	String symbolIndex;
	String settleCurrency;
	double contractValue;
	int status;
	double priceCNY;
	double open;
	double high;
	double low;
	double close;
	double chg;
	double volume;
	double turnover;
	double time;
	double capitalRate;
	double currCapitalRate;
}
