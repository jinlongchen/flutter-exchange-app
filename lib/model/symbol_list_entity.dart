import 'package:hibi/generated/json/base/json_convert_content.dart';

class SymbolListEntity with JsonConvert<SymbolListEntity> {
	int code;
	String message;
	List<SymbolListData> data;
}

class SymbolListData with JsonConvert<SymbolListData> {
	String symbol;
	String baseSymbol;
	int baseScale;
	String coinSymbol;
	int coinScale;
	double fee;
	dynamic digit;
	String infolink;
	int enableMarketBuy;
	int enableMarketSell;
	int exchangeable;
	int visible;
	int status;
	String startTime;
	String endTime;
	int zone;
	double priceCNY;
	double open;
	double high;
	double low;
	double close;
	double chg;
	double change;
	double volume;
	double turnover;
	List<double> trend;

	bool isCollect = false;
}
