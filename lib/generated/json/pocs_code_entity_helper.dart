import 'package:hibi/model/pocs_code_entity.dart';

pocsCodeEntityFromJson(PocsCodeEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new PocsCodeData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pocsCodeEntityToJson(PocsCodeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pocsCodeDataFromJson(PocsCodeData data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new List<PocsCodeDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new PocsCodeDataData().fromJson(v));
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

Map<String, dynamic> pocsCodeDataToJson(PocsCodeData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['total'] = entity.total;
	data['totalPage'] = entity.totalPage;
	return data;
}

pocsCodeDataDataFromJson(PocsCodeDataData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['buyMemberId'] != null) {
		data.buyMemberId = json['buyMemberId']?.toInt();
	}
	if (json['useMemberId'] != null) {
		data.useMemberId = json['useMemberId']?.toInt();
	}
	if (json['buyCode'] != null) {
		data.buyCode = json['buyCode']?.toString();
	}
	if (json['useStatus'] != null) {
		data.useStatus = json['useStatus']?.toInt();
	}
	if (json['coinName'] != null) {
		data.coinName = json['coinName']?.toString();
	}
	if (json['coinMoney'] != null) {
		data.coinMoney = json['coinMoney']?.toDouble();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime']?.toString();
	}
	if (json['buyUserName'] != null) {
		data.buyUserName = json['buyUserName']?.toString();
	}
	if (json['useUserName'] != null) {
		data.useUserName = json['useUserName']?.toString();
	}
	return data;
}

Map<String, dynamic> pocsCodeDataDataToJson(PocsCodeDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['buyMemberId'] = entity.buyMemberId;
	data['useMemberId'] = entity.useMemberId;
	data['buyCode'] = entity.buyCode;
	data['useStatus'] = entity.useStatus;
	data['coinName'] = entity.coinName;
	data['coinMoney'] = entity.coinMoney;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['buyUserName'] = entity.buyUserName;
	data['useUserName'] = entity.useUserName;
	return data;
}