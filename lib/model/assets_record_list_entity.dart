import 'package:hibi/generated/json/base/json_convert_content.dart';

class AssetsRecordListEntity with JsonConvert<AssetsRecordListEntity> {
	int code;
	String message;
	AssetsRecordListData data;
}

class AssetsRecordListData with JsonConvert<AssetsRecordListData> {
	int pageNo;
	int pageSize;
	int totalPage;
	int total;
	List<AssetsRecordListDataData> data;
}

class AssetsRecordListDataData with JsonConvert<AssetsRecordListDataData> {
	int id;
	int memberId;
	double amount;
	int fee;
	String discountFee;
	dynamic flag;
	String realFee;
	String symbol;
	int type;
	dynamic remark;
	String createTime;
}
