import 'package:hibi/model/user_entity.dart';

userEntityFromJson(UserEntity data, Map<String, dynamic> json) {
	if (json['content'] != null) {
		data.content = json['content'];
	}
	if (json['totalElements'] != null) {
		data.totalElements = json['totalElements']?.toInt();
	}
	if (json['totalPages'] != null) {
		data.totalPages = json['totalPages']?.toInt();
	}
	if (json['last'] != null) {
		data.last = json['last'];
	}
	if (json['number'] != null) {
		data.number = json['number']?.toInt();
	}
	if (json['size'] != null) {
		data.size = json['size']?.toInt();
	}
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new UserData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> userEntityToJson(UserEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['content'] = entity.content;
	data['totalElements'] = entity.totalElements;
	data['totalPages'] = entity.totalPages;
	data['last'] = entity.last;
	data['number'] = entity.number;
	data['size'] = entity.size;
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

userDataFromJson(UserData data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['realVerified'] != null) {
		data.realVerified = json['realVerified']?.toInt();
	}
	if (json['emailVerified'] != null) {
		data.emailVerified = json['emailVerified']?.toInt();
	}
	if (json['phoneVerified'] != null) {
		data.phoneVerified = json['phoneVerified']?.toInt();
	}
	if (json['loginVerified'] != null) {
		data.loginVerified = json['loginVerified']?.toInt();
	}
	if (json['fundsVerified'] != null) {
		data.fundsVerified = json['fundsVerified']?.toInt();
	}
	if (json['realAuditing'] != null) {
		data.realAuditing = json['realAuditing']?.toInt();
	}
	if (json['mobilePhone'] != null) {
		data.mobilePhone = json['mobilePhone']?.toString();
	}
	if (json['email'] != null) {
		data.email = json['email'];
	}
	if (json['realName'] != null) {
		data.realName = json['realName'];
	}
	if (json['realNameRejectReason'] != null) {
		data.realNameRejectReason = json['realNameRejectReason'];
	}
	if (json['idCard'] != null) {
		data.idCard = json['idCard'];
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'];
	}
	if (json['accountVerified'] != null) {
		data.accountVerified = json['accountVerified']?.toInt();
	}
	if (json['googleStatus'] != null) {
		data.googleStatus = json['googleStatus'];
	}
	return data;
}

Map<String, dynamic> userDataToJson(UserData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['id'] = entity.id;
	data['createTime'] = entity.createTime;
	data['realVerified'] = entity.realVerified;
	data['emailVerified'] = entity.emailVerified;
	data['phoneVerified'] = entity.phoneVerified;
	data['loginVerified'] = entity.loginVerified;
	data['fundsVerified'] = entity.fundsVerified;
	data['realAuditing'] = entity.realAuditing;
	data['mobilePhone'] = entity.mobilePhone;
	data['email'] = entity.email;
	data['realName'] = entity.realName;
	data['realNameRejectReason'] = entity.realNameRejectReason;
	data['idCard'] = entity.idCard;
	data['avatar'] = entity.avatar;
	data['accountVerified'] = entity.accountVerified;
	data['googleStatus'] = entity.googleStatus;
	return data;
}