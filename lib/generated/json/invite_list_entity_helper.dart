import 'package:hibi/model/invite_list_entity.dart';

inviteListEntityFromJson(InviteListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new InviteListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> inviteListEntityToJson(InviteListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

inviteListDataFromJson(InviteListData data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new List<InviteListDataData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new InviteListDataData().fromJson(v));
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

Map<String, dynamic> inviteListDataToJson(InviteListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['total'] = entity.total;
	data['totalPage'] = entity.totalPage;
	return data;
}

inviteListDataDataFromJson(InviteListDataData data, Map<String, dynamic> json) {
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['level'] != null) {
		data.level = json['level']?.toInt();
	}
	if (json['realNameStatus'] != null) {
		data.realNameStatus = json['realNameStatus']?.toInt();
	}
	if (json['totalCalcula'] != null) {
		data.totalCalcula = json['totalCalcula']?.toInt();
	}
	return data;
}

Map<String, dynamic> inviteListDataDataToJson(InviteListDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['createTime'] = entity.createTime;
	data['username'] = entity.username;
	data['level'] = entity.level;
	data['realNameStatus'] = entity.realNameStatus;
	data['totalCalcula'] = entity.totalCalcula;
	return data;
}