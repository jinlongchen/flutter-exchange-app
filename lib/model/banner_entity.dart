import 'package:hibi/generated/json/base/json_convert_content.dart';

class BannerEntity with JsonConvert<BannerEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	List<BannerData> data;
}

class BannerData with JsonConvert<BannerData> {
	String serialNumber;
	String name;
	int sysAdvertiseLocation;
	String lang;
	String startTime;
	String endTime;
	String url;
	String linkUrl;
	String remark;
	int status;
	dynamic createTime;
	dynamic content;
	dynamic author;
	int sort;
}
