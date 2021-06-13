import 'package:hibi/generated/json/base/json_convert_content.dart';

class PyramidRedeemEntity with JsonConvert<PyramidRedeemEntity> {
	int code;
	String message;
	PyramidRedeemData data;
}

class PyramidRedeemData with JsonConvert<PyramidRedeemData> {
	List<PyramidRedeemDataData> data;
	int total;
	int totalPage;
}

class PyramidRedeemDataData with JsonConvert<PyramidRedeemDataData> {
	dynamic orderId;
	String projectId;
	int buyNum;
	dynamic days;
	dynamic status;
	dynamic pocsIncrease;
	dynamic productYield;
	String redeemTime;
}
