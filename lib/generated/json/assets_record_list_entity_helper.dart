import 'package:hibi/model/assets_record_list_entity.dart';

assetsRecordListEntityFromJson(AssetsRecordListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new AssetsRecordListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> assetsRecordListEntityToJson(AssetsRecordListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

assetsRecordListDataFromJson(AssetsRecordListData data, Map<String, dynamic> json) {
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
		data.data = new List<AssetsRecordListDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new AssetsRecordListDataData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> assetsRecordListDataToJson(AssetsRecordListData entity) {
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

assetsRecordListDataDataFromJson(AssetsRecordListDataData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toDouble();
	}
	if (json['fee'] != null) {
		data.fee = json['fee']?.toInt();
	}
	if (json['discountFee'] != null) {
		data.discountFee = json['discountFee']?.toString();
	}
	if (json['flag'] != null) {
		data.flag = json['flag'];
	}
	if (json['realFee'] != null) {
		data.realFee = json['realFee']?.toString();
	}
	if (json['symbol'] != null) {
		data.symbol = json['symbol']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toInt();
	}
	if (json['remark'] != null) {
		data.remark = json['remark'];
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	return data;
}

Map<String, dynamic> assetsRecordListDataDataToJson(AssetsRecordListDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['memberId'] = entity.memberId;
	data['amount'] = entity.amount;
	data['fee'] = entity.fee;
	data['discountFee'] = entity.discountFee;
	data['flag'] = entity.flag;
	data['realFee'] = entity.realFee;
	data['symbol'] = entity.symbol;
	data['type'] = entity.type;
	data['remark'] = entity.remark;
	data['createTime'] = entity.createTime;
	return data;
}