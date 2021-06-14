import 'package:hibi/model/pyramid_reciprocal_entity.dart';

pyramidReciprocalEntityFromJson(PyramidReciprocalEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new PyramidReciprocalData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pyramidReciprocalEntityToJson(PyramidReciprocalEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pyramidReciprocalDataFromJson(PyramidReciprocalData data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new List<PyramidReciprocalDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new PyramidReciprocalDataData().fromJson(v));
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

Map<String, dynamic> pyramidReciprocalDataToJson(PyramidReciprocalData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['total'] = entity.total;
	data['totalPage'] = entity.totalPage;
	return data;
}

pyramidReciprocalDataDataFromJson(PyramidReciprocalDataData data, Map<String, dynamic> json) {
	if (json['userName'] != null) {
		data.userName = json['userName']?.toString();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	return data;
}

Map<String, dynamic> pyramidReciprocalDataDataToJson(PyramidReciprocalDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['userName'] = entity.userName;
	data['memberId'] = entity.memberId;
	data['createTime'] = entity.createTime;
	return data;
}