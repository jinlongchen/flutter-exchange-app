import 'package:hibi/generated/json/base/json_convert_content.dart';

class VersionEntity with JsonConvert<VersionEntity> {
	int code;
	String message;
	VersionData data;
}

class VersionData with JsonConvert<VersionData> {
	int id;
	String versionName;
	String versionCode;
	String description;
	String url;
	int isUpdate;
	int appType;
	String createTime;
	String updateTime;
}
