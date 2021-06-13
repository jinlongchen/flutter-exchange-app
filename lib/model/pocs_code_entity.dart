import 'package:hibi/generated/json/base/json_convert_content.dart';

class PocsCodeEntity with JsonConvert<PocsCodeEntity> {
	int code;
	String message;
	PocsCodeData data;
}

class PocsCodeData with JsonConvert<PocsCodeData> {
	List<PocsCodeDataData> data;
	int total;
	int totalPage;
}

class PocsCodeDataData with JsonConvert<PocsCodeDataData> {
	int id;
	int buyMemberId;
	int useMemberId;
	String buyCode;
	int useStatus;
	String coinName;
	double coinMoney;
	String createTime;
	String updateTime;
	String buyUserName;
	String useUserName;
}
