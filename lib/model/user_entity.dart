import 'package:hibi/generated/json/base/json_convert_content.dart';

class UserEntity with JsonConvert<UserEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	UserData data;
}

class UserData with JsonConvert<UserData> {
	String username;
	int id;
	String createTime;
	int realVerified;
	int emailVerified;
	int phoneVerified;
	int loginVerified;
	int fundsVerified;
	int realAuditing;
	String mobilePhone;
	dynamic email;
	dynamic realName;
	dynamic realNameRejectReason;
	dynamic idCard;
	dynamic avatar;
	int accountVerified;
	dynamic googleStatus;
}
