import 'package:hibi/generated/json/base/json_convert_content.dart';

class PocsListEntity with JsonConvert<PocsListEntity> {
	int code;
	String message;
	PocsListData data;
}

class PocsListData with JsonConvert<PocsListData> {
	List<PocsListDataData> data;
	int total;
	int totalPage;
}

class PocsListDataData with JsonConvert<PocsListDataData> {
	dynamic username;
	dynamic email;
	dynamic mobilePhone;
	dynamic startTime;
	dynamic endTime;
	int id;
	int memberId;
	int purchaseId;
	int status;
	String purchaseCurrencyId;
	double purchasePrice;
	String payCurrencyId;
	int discount;
	dynamic totalMoney;
	dynamic totalNumber;
	int realMoney;
	double realNumber;
	dynamic completeTime;
	String createTime;
	String updateTime;
	dynamic avatar;
}
