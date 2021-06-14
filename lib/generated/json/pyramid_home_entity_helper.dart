import 'package:hibi/model/pyramid_home_entity.dart';

pyramidHomeEntityFromJson(PyramidHomeEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new PyramidHomeData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pyramidHomeEntityToJson(PyramidHomeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pyramidHomeDataFromJson(PyramidHomeData data, Map<String, dynamic> json) {
	if (json['communityClass'] != null) {
		data.communityClass = json['communityClass']?.toInt();
	}
	if (json['productNum'] != null) {
		data.productNum = json['productNum']?.toInt();
	}
	if (json['productTotal'] != null) {
		data.productTotal = json['productTotal']?.toDouble();
	}
	if (json['holdPosition'] != null) {
		data.holdPosition = json['holdPosition']?.toDouble();
	}
	if (json['interestSum'] != null) {
		data.interestSum = json['interestSum']?.toDouble();
	}
	if (json['invite'] != null) {
		data.invite = json['invite']?.toDouble();
	}
	if (json['pocsIncrease'] != null) {
		data.pocsIncrease = json['pocsIncrease']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	return data;
}

Map<String, dynamic> pyramidHomeDataToJson(PyramidHomeData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['communityClass'] = entity.communityClass;
	data['productNum'] = entity.productNum;
	data['productTotal'] = entity.productTotal;
	data['holdPosition'] = entity.holdPosition;
	data['interestSum'] = entity.interestSum;
	data['invite'] = entity.invite;
	data['pocsIncrease'] = entity.pocsIncrease;
	data['status'] = entity.status;
	return data;
}