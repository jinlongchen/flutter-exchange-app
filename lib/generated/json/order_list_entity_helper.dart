import 'package:hibi/model/order_list_entity.dart';

orderListEntityFromJson(OrderListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new OrderListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> orderListEntityToJson(OrderListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

orderListDataFromJson(OrderListData data, Map<String, dynamic> json) {
	if (json['pageNo'] != null) {
		data.pageNo = json['pageNo']?.toInt();
	}
	if (json['pageSize'] != null) {
		data.pageSize = json['pageSize']?.toInt();
	}
	if (json['totalPage'] != null) {
		data.totalPage = json['totalPage']?.toInt();
	}
	if (json['total'] != null) {
		data.total = json['total']?.toInt();
	}
	if (json['data'] != null) {
		data.data = new List<OrderListDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new OrderListDataData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> orderListDataToJson(OrderListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pageNo'] = entity.pageNo;
	data['pageSize'] = entity.pageSize;
	data['totalPage'] = entity.totalPage;
	data['total'] = entity.total;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

orderListDataDataFromJson(OrderListDataData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['orderSn'] != null) {
		data.orderSn = json['orderSn']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toDouble();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toDouble();
	}
	if (json['fee'] != null) {
		data.fee = json['fee']?.toDouble();
	}
	if (json['symbol'] != null) {
		data.symbol = json['symbol']?.toString();
	}
	if (json['baseSymbol'] != null) {
		data.baseSymbol = json['baseSymbol']?.toString();
	}
	if (json['coinSymbol'] != null) {
		data.coinSymbol = json['coinSymbol']?.toString();
	}
	if (json['direction'] != null) {
		data.direction = json['direction']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['tradedAmount'] != null) {
		data.tradedAmount = json['tradedAmount']?.toDouble();
	}
	if (json['turnover'] != null) {
		data.turnover = json['turnover']?.toDouble();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toInt();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toInt();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime']?.toInt();
	}
	if (json['useDiscount'] != null) {
		data.useDiscount = json['useDiscount']?.toString();
	}
	if (json['orderNo'] != null) {
		data.orderNo = json['orderNo']?.toString();
	}
	return data;
}

Map<String, dynamic> orderListDataDataToJson(OrderListDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['orderSn'] = entity.orderSn;
	data['memberId'] = entity.memberId;
	data['price'] = entity.price;
	data['amount'] = entity.amount;
	data['fee'] = entity.fee;
	data['symbol'] = entity.symbol;
	data['baseSymbol'] = entity.baseSymbol;
	data['coinSymbol'] = entity.coinSymbol;
	data['direction'] = entity.direction;
	data['status'] = entity.status;
	data['tradedAmount'] = entity.tradedAmount;
	data['turnover'] = entity.turnover;
	data['type'] = entity.type;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['useDiscount'] = entity.useDiscount;
	data['orderNo'] = entity.orderNo;
	return data;
}