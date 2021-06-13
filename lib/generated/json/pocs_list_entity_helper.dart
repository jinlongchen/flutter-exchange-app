import 'package:hibi/model/pocs_list_entity.dart';

pocsListEntityFromJson(PocsListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new PocsListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pocsListEntityToJson(PocsListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pocsListDataFromJson(PocsListData data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new List<PocsListDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new PocsListDataData().fromJson(v));
		});
	}
	if (json['total'] != null) {
		data.total = json['total']?.toInt();
	}
	if (json['totalPage'] != null) {
		data.totalPage = json['totalPage']?.toInt();
	}
	return data;
}

Map<String, dynamic> pocsListDataToJson(PocsListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['total'] = entity.total;
	data['totalPage'] = entity.totalPage;
	return data;
}

pocsListDataDataFromJson(PocsListDataData data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username'];
	}
	if (json['email'] != null) {
		data.email = json['email'];
	}
	if (json['mobilePhone'] != null) {
		data.mobilePhone = json['mobilePhone'];
	}
	if (json['startTime'] != null) {
		data.startTime = json['startTime'];
	}
	if (json['endTime'] != null) {
		data.endTime = json['endTime'];
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['purchaseId'] != null) {
		data.purchaseId = json['purchaseId']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['purchaseCurrencyId'] != null) {
		data.purchaseCurrencyId = json['purchaseCurrencyId']?.toString();
	}
	if (json['purchasePrice'] != null) {
		data.purchasePrice = json['purchasePrice']?.toDouble();
	}
	if (json['payCurrencyId'] != null) {
		data.payCurrencyId = json['payCurrencyId']?.toString();
	}
	if (json['discount'] != null) {
		data.discount = json['discount']?.toInt();
	}
	if (json['totalMoney'] != null) {
		data.totalMoney = json['totalMoney'];
	}
	if (json['totalNumber'] != null) {
		data.totalNumber = json['totalNumber'];
	}
	if (json['realMoney'] != null) {
		data.realMoney = json['realMoney']?.toInt();
	}
	if (json['realNumber'] != null) {
		data.realNumber = json['realNumber']?.toDouble();
	}
	if (json['completeTime'] != null) {
		data.completeTime = json['completeTime'];
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'];
	}
	return data;
}

Map<String, dynamic> pocsListDataDataToJson(PocsListDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['email'] = entity.email;
	data['mobilePhone'] = entity.mobilePhone;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['id'] = entity.id;
	data['memberId'] = entity.memberId;
	data['purchaseId'] = entity.purchaseId;
	data['status'] = entity.status;
	data['purchaseCurrencyId'] = entity.purchaseCurrencyId;
	data['purchasePrice'] = entity.purchasePrice;
	data['payCurrencyId'] = entity.payCurrencyId;
	data['discount'] = entity.discount;
	data['totalMoney'] = entity.totalMoney;
	data['totalNumber'] = entity.totalNumber;
	data['realMoney'] = entity.realMoney;
	data['realNumber'] = entity.realNumber;
	data['completeTime'] = entity.completeTime;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['avatar'] = entity.avatar;
	return data;
}