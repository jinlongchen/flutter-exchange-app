import 'package:hibi/model/socket_info_entity.dart';

socketInfoEntityFromJson(SocketInfoEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new SocketInfoData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> socketInfoEntityToJson(SocketInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

socketInfoDataFromJson(SocketInfoData data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['password'] != null) {
		data.password = json['password']?.toString();
	}
	if (json['host'] != null) {
		data.host = json['host']?.toString();
	}
	if (json['wsPort'] != null) {
		data.wsPort = json['wsPort']?.toString();
	}
	if (json['wssPort'] != null) {
		data.wssPort = json['wssPort']?.toString();
	}
	if (json['tcpPort'] != null) {
		data.tcpPort = json['tcpPort']?.toString();
	}
	if (json['path'] != null) {
		data.path = json['path']?.toString();
	}
	return data;
}

Map<String, dynamic> socketInfoDataToJson(SocketInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['password'] = entity.password;
	data['host'] = entity.host;
	data['wsPort'] = entity.wsPort;
	data['wssPort'] = entity.wssPort;
	data['tcpPort'] = entity.tcpPort;
	data['path'] = entity.path;
	return data;
}