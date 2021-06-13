import 'package:hibi/model/invite_info_entity.dart';

inviteInfoEntityFromJson(InviteInfoEntity data, Map<String, dynamic> json) {
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
		data.data = new InviteInfoData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> inviteInfoEntityToJson(InviteInfoEntity entity) {
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

inviteInfoDataFromJson(InviteInfoData data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['location'] != null) {
		data.location = json['location'];
	}
	if (json['memberLevel'] != null) {
		data.memberLevel = json['memberLevel']?.toInt();
	}
	if (json['token'] != null) {
		data.token = json['token']?.toString();
	}
	if (json['realName'] != null) {
		data.realName = json['realName']?.toString();
	}
	if (json['country'] != null) {
		data.country = new InviteInfoDataCountry().fromJson(json['country']);
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'];
	}
	if (json['promotionCode'] != null) {
		data.promotionCode = json['promotionCode']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['loginCount'] != null) {
		data.loginCount = json['loginCount']?.toInt();
	}
	if (json['superPartner'] != null) {
		data.superPartner = json['superPartner'];
	}
	if (json['promotionPrefix'] != null) {
		data.promotionPrefix = json['promotionPrefix']?.toString();
	}
	if (json['signInAbility'] != null) {
		data.signInAbility = json['signInAbility'];
	}
	if (json['firstLevel'] != null) {
		data.firstLevel = json['firstLevel']?.toInt();
	}
	if (json['secondLevel'] != null) {
		data.secondLevel = json['secondLevel']?.toInt();
	}
	if (json['thirdLevel'] != null) {
		data.thirdLevel = json['thirdLevel']?.toInt();
	}
	if (json['teamNumber'] != null) {
		data.teamNumber = json['teamNumber']?.toInt();
	}
	if (json['signInActivity'] != null) {
		data.signInActivity = json['signInActivity'];
	}
	if (json['memberRate'] != null) {
		data.memberRate = json['memberRate'];
	}
	return data;
}

Map<String, dynamic> inviteInfoDataToJson(InviteInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['location'] = entity.location;
	data['memberLevel'] = entity.memberLevel;
	data['token'] = entity.token;
	data['realName'] = entity.realName;
	if (entity.country != null) {
		data['country'] = entity.country.toJson();
	}
	data['avatar'] = entity.avatar;
	data['promotionCode'] = entity.promotionCode;
	data['id'] = entity.id;
	data['loginCount'] = entity.loginCount;
	data['superPartner'] = entity.superPartner;
	data['promotionPrefix'] = entity.promotionPrefix;
	data['signInAbility'] = entity.signInAbility;
	data['firstLevel'] = entity.firstLevel;
	data['secondLevel'] = entity.secondLevel;
	data['thirdLevel'] = entity.thirdLevel;
	data['teamNumber'] = entity.teamNumber;
	data['signInActivity'] = entity.signInActivity;
	data['memberRate'] = entity.memberRate;
	return data;
}

inviteInfoDataCountryFromJson(InviteInfoDataCountry data, Map<String, dynamic> json) {
	if (json['zhName'] != null) {
		data.zhName = json['zhName']?.toString();
	}
	if (json['enName'] != null) {
		data.enName = json['enName']?.toString();
	}
	if (json['areaCode'] != null) {
		data.areaCode = json['areaCode']?.toString();
	}
	if (json['language'] != null) {
		data.language = json['language']?.toString();
	}
	if (json['localCurrency'] != null) {
		data.localCurrency = json['localCurrency']?.toString();
	}
	if (json['sort'] != null) {
		data.sort = json['sort']?.toInt();
	}
	return data;
}

Map<String, dynamic> inviteInfoDataCountryToJson(InviteInfoDataCountry entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['zhName'] = entity.zhName;
	data['enName'] = entity.enName;
	data['areaCode'] = entity.areaCode;
	data['language'] = entity.language;
	data['localCurrency'] = entity.localCurrency;
	data['sort'] = entity.sort;
	return data;
}