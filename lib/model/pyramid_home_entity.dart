import 'package:hibi/generated/json/base/json_convert_content.dart';

class PyramidHomeEntity with JsonConvert<PyramidHomeEntity> {
	int code;
	String message;
	PyramidHomeData data;
}

class PyramidHomeData with JsonConvert<PyramidHomeData> {
	int communityClass;
	int productNum;
	double productTotal;
	double holdPosition;
	double interestSum;
	double invite;
	String pocsIncrease;
	int status;
}
