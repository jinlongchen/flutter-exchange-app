import 'package:hibi/generated/json/base/json_convert_content.dart';

class PyramidMineEntity with JsonConvert<PyramidMineEntity> {
	int code;
	String message;
	PyramidMineData data;
}

class PyramidMineData with JsonConvert<PyramidMineData> {
	List<PyramidMineDataData> data;
	int total;
	int totalPage;
}

class PyramidMineDataData with JsonConvert<PyramidMineDataData> {
	int orderId;
	String projectId;
	int buyNum;
	int days;
	int status;
	double pocsIncrease;
	double productYield;
	dynamic redeemTime;
}
