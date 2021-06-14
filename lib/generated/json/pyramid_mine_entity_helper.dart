import 'package:hibi/model/pyramid_mine_entity.dart';

pyramidMineEntityFromJson(PyramidMineEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new PyramidMineData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pyramidMineEntityToJson(PyramidMineEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pyramidMineDataFromJson(PyramidMineData data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new List<PyramidMineDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new PyramidMineDataData().fromJson(v));
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

Map<String, dynamic> pyramidMineDataToJson(PyramidMineData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['total'] = entity.total;
	data['totalPage'] = entity.totalPage;
	return data;
}

pyramidMineDataDataFromJson(PyramidMineDataData data, Map<String, dynamic> json) {
	if (json['orderId'] != null) {
		data.orderId = json['orderId']?.toInt();
	}
	if (json['projectId'] != null) {
		data.projectId = json['projectId']?.toString();
	}
	if (json['buyNum'] != null) {
		data.buyNum = json['buyNum']?.toInt();
	}
	if (json['days'] != null) {
		data.days = json['days']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['pocsIncrease'] != null) {
		data.pocsIncrease = json['pocsIncrease']?.toDouble();
	}
	if (json['productYield'] != null) {
		data.productYield = json['productYield']?.toDouble();
	}
	if (json['redeemTime'] != null) {
		data.redeemTime = json['redeemTime'];
	}
	return data;
}

Map<String, dynamic> pyramidMineDataDataToJson(PyramidMineDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['orderId'] = entity.orderId;
	data['projectId'] = entity.projectId;
	data['buyNum'] = entity.buyNum;
	data['days'] = entity.days;
	data['status'] = entity.status;
	data['pocsIncrease'] = entity.pocsIncrease;
	data['productYield'] = entity.productYield;
	data['redeemTime'] = entity.redeemTime;
	return data;
}