import 'package:hibi/model/banner_entity.dart';

bannerEntityFromJson(BannerEntity data, Map<String, dynamic> json) {
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
		data.data = new List<BannerData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new BannerData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> bannerEntityToJson(BannerEntity entity) {
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
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

bannerDataFromJson(BannerData data, Map<String, dynamic> json) {
	if (json['serialNumber'] != null) {
		data.serialNumber = json['serialNumber']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['sysAdvertiseLocation'] != null) {
		data.sysAdvertiseLocation = json['sysAdvertiseLocation']?.toInt();
	}
	if (json['lang'] != null) {
		data.lang = json['lang']?.toString();
	}
	if (json['startTime'] != null) {
		data.startTime = json['startTime']?.toString();
	}
	if (json['endTime'] != null) {
		data.endTime = json['endTime']?.toString();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	if (json['linkUrl'] != null) {
		data.linkUrl = json['linkUrl']?.toString();
	}
	if (json['remark'] != null) {
		data.remark = json['remark']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime'];
	}
	if (json['content'] != null) {
		data.content = json['content'];
	}
	if (json['author'] != null) {
		data.author = json['author'];
	}
	if (json['sort'] != null) {
		data.sort = json['sort']?.toInt();
	}
	return data;
}

Map<String, dynamic> bannerDataToJson(BannerData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['serialNumber'] = entity.serialNumber;
	data['name'] = entity.name;
	data['sysAdvertiseLocation'] = entity.sysAdvertiseLocation;
	data['lang'] = entity.lang;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['url'] = entity.url;
	data['linkUrl'] = entity.linkUrl;
	data['remark'] = entity.remark;
	data['status'] = entity.status;
	data['createTime'] = entity.createTime;
	data['content'] = entity.content;
	data['author'] = entity.author;
	data['sort'] = entity.sort;
	return data;
}