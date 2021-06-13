import 'package:hibi/generated/json/base/json_convert_content.dart';

class ActivityHistroyEntity with JsonConvert<ActivityHistroyEntity> {
	int code;
	String message;
	ActivityHistroyData data;
}

class ActivityHistroyData with JsonConvert<ActivityHistroyData> {
	List<ActivityHistroyDataData> data;
	int total;
	int totalPage;
}

class ActivityHistroyDataData with JsonConvert<ActivityHistroyDataData> {
	String username;
	dynamic email;
	String mobilePhone;
	dynamic startTime;
	dynamic endTime;
	int id;
	int activityId;
	int memberId;
	String currencyId;
	double amount;
	double sendAmount;
	double waitAmount;
	String runTime;
	int status;
	int runStatus;
	dynamic activityName;
	String createTime;
	dynamic updateTime;
}
