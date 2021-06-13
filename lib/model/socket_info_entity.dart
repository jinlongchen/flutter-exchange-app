import 'package:hibi/generated/json/base/json_convert_content.dart';

class SocketInfoEntity with JsonConvert<SocketInfoEntity> {
	int code;
	String message;
	SocketInfoData data;
}

class SocketInfoData with JsonConvert<SocketInfoData> {
	String username;
	String password;
	String host;
	String wsPort;
	String wssPort;
	String tcpPort;
	String path;
}
