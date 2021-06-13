import 'package:hibi/generated/json/base/json_convert_content.dart';

class InviteListEntity with JsonConvert<InviteListEntity> {
	int code;
	String message;
	InviteListData data;
}

class InviteListData with JsonConvert<InviteListData> {
	List<InviteListDataData> data;
	int total;
	int totalPage;
}

class InviteListDataData with JsonConvert<InviteListDataData> {
	String createTime;
	String username;
	int level;
	int realNameStatus;
	int totalCalcula;
}
