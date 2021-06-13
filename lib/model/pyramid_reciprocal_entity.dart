import 'package:hibi/generated/json/base/json_convert_content.dart';

class PyramidReciprocalEntity with JsonConvert<PyramidReciprocalEntity> {
	int code;
	String message;
	PyramidReciprocalData data;
}

class PyramidReciprocalData with JsonConvert<PyramidReciprocalData> {
	List<PyramidReciprocalDataData> data;
	int total;
	int totalPage;
}

class PyramidReciprocalDataData with JsonConvert<PyramidReciprocalDataData> {
	String userName;
	int memberId;
	String createTime;
}
