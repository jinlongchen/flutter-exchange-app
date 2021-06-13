import 'package:hibi/generated/json/base/json_convert_content.dart';

class OrderListEntity with JsonConvert<OrderListEntity> {
	int code;
	String message;
	OrderListData data;
}

class OrderListData with JsonConvert<OrderListData> {
	int pageNo;
	int pageSize;
	int totalPage;
	int total;
	List<OrderListDataData> data;
}

class OrderListDataData with JsonConvert<OrderListDataData> {
	int id;
	int orderSn;
	int memberId;
	double price;
	double amount;
	double fee;
	String symbol;
	String baseSymbol;
	String coinSymbol;
	int direction;
	int status;
	double tradedAmount;
	double turnover;
	int type;
	int createTime;
	int updateTime;
	String useDiscount;
	String orderNo;
}
