import 'package:hibi/generated/json/base/json_convert_content.dart';

class InviteInfoEntity with JsonConvert<InviteInfoEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	InviteInfoData data;
}

class InviteInfoData with JsonConvert<InviteInfoData> {
	String username;
	dynamic location;
	int memberLevel;
	String token;
	String realName;
	InviteInfoDataCountry country;
	dynamic avatar;
	String promotionCode;
	int id;
	int loginCount;
	dynamic superPartner;
	String promotionPrefix;
	bool signInAbility;
	int firstLevel;
	int secondLevel;
	int thirdLevel;
	int teamNumber;
	bool signInActivity;
	dynamic memberRate;
}

class InviteInfoDataCountry with JsonConvert<InviteInfoDataCountry> {
	String zhName;
	String enName;
	String areaCode;
	String language;
	String localCurrency;
	int sort;
}
