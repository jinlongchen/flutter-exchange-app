import 'package:hibi/generated/json/base/json_convert_content.dart';

class PocsInfoEntity with JsonConvert<PocsInfoEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	PocsInfoData data;
}

class PocsInfoData with JsonConvert<PocsInfoData> {
	String purchaseStartTime;
	String everyDayStartTime;
	String everyDayEndTime;
	int status;
	int countdown;
	String purchaseCurrencyId;
	String purchaseCurrencyName;
	String payCurrencyId;
	String payCurrencyName;
	int thisId;
	String content;
	String name;
	double totalNumber;
	double everyDayNumber;
	String discount;
	double price;
	double averagePrice;
	String expectedPurchaseNumber;
	double aboutUSDTMoney;
	String nowPurchasePrice;
	String nowDiscount;
	double purchaseMoney;
	String myMirrorCalcula;
	String myRealCalcula;
	String myAllCalcula;
	PocsInfoDataAtPresentCalculate atPresentCalculate;
}

class PocsInfoDataAtPresentCalculate with JsonConvert<PocsInfoDataAtPresentCalculate> {
	String allCalcula;
	String realCalcula;
	String mirrorCalcula;
	String calculaWallet;
	String purchaseWallet;
	String continuous;
	String promote;
	String community;
	String regist;
	String activity;
	String finance;
}
