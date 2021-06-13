import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/generated/json/base/json_filed.dart';

class PyramidProductEntity with JsonConvert<PyramidProductEntity> {
	int code;
	String message;
	List<PyramidProductData> data;
}

class PyramidProductData with JsonConvert<PyramidProductData> {
	String level;
	int mealNum;
	String currencyId;
	@JSONField(name: "yield")
	double xYield;
	int status;
	int maxNum;
	int period;
}
