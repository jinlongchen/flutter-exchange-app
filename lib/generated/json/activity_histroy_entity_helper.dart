import 'package:hibi/model/activity_histroy_entity.dart';

activityHistroyEntityFromJson(ActivityHistroyEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new ActivityHistroyData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> activityHistroyEntityToJson(ActivityHistroyEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

activityHistroyDataFromJson(ActivityHistroyData data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new List<ActivityHistroyDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new ActivityHistroyDataData().fromJson(v));
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

Map<String, dynamic> activityHistroyDataToJson(ActivityHistroyData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['total'] = entity.total;
	data['totalPage'] = entity.totalPage;
	return data;
}

activityHistroyDataDataFromJson(ActivityHistroyDataData data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['email'] != null) {
		data.email = json['email'];
	}
	if (json['mobilePhone'] != null) {
		data.mobilePhone = json['mobilePhone']?.toString();
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
	if (json['activityId'] != null) {
		data.activityId = json['activityId']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['currencyId'] != null) {
		data.currencyId = json['currencyId']?.toString();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toDouble();
	}
	if (json['sendAmount'] != null) {
		data.sendAmount = json['sendAmount']?.toDouble();
	}
	if (json['waitAmount'] != null) {
		data.waitAmount = json['waitAmount']?.toDouble();
	}
	if (json['runTime'] != null) {
		data.runTime = json['runTime']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['runStatus'] != null) {
		data.runStatus = json['runStatus']?.toInt();
	}
	if (json['activityName'] != null) {
		data.activityName = json['activityName'];
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime'];
	}
	return data;
}

Map<String, dynamic> activityHistroyDataDataToJson(ActivityHistroyDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['email'] = entity.email;
	data['mobilePhone'] = entity.mobilePhone;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['id'] = entity.id;
	data['activityId'] = entity.activityId;
	data['memberId'] = entity.memberId;
	data['currencyId'] = entity.currencyId;
	data['amount'] = entity.amount;
	data['sendAmount'] = entity.sendAmount;
	data['waitAmount'] = entity.waitAmount;
	data['runTime'] = entity.runTime;
	data['status'] = entity.status;
	data['runStatus'] = entity.runStatus;
	data['activityName'] = entity.activityName;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	return data;
}