import 'package:hibi/model/version_entity.dart';

versionEntityFromJson(VersionEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new VersionData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> versionEntityToJson(VersionEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

versionDataFromJson(VersionData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['versionName'] != null) {
		data.versionName = json['versionName']?.toString();
	}
	if (json['versionCode'] != null) {
		data.versionCode = json['versionCode']?.toString();
	}
	if (json['description'] != null) {
		data.description = json['description']?.toString();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	if (json['isUpdate'] != null) {
		data.isUpdate = json['isUpdate']?.toInt();
	}
	if (json['appType'] != null) {
		data.appType = json['appType']?.toInt();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime']?.toString();
	}
	return data;
}

Map<String, dynamic> versionDataToJson(VersionData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['versionName'] = entity.versionName;
	data['versionCode'] = entity.versionCode;
	data['description'] = entity.description;
	data['url'] = entity.url;
	data['isUpdate'] = entity.isUpdate;
	data['appType'] = entity.appType;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	return data;
}