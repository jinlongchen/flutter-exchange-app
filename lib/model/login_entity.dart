import 'package:hibi/generated/json/base/json_convert_content.dart';

class LoginEntity with JsonConvert<LoginEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	LoginData data;
}

class LoginData with JsonConvert<LoginData> {
	String username;
	LoginDataLocation location;
	int memberLevel;
	String token;
	dynamic realName;
	LoginDataCountry country;
	dynamic avatar;
	String promotionCode;
	int id;
	int loginCount;
	String superPartner;
	String promotionPrefix;
	bool signInAbility;
	int firstLevel;
	int secondLevel;
	int thirdLevel;
	int teamNumber;
	bool signInActivity;
	dynamic memberRate;
}

class LoginDataLocation with JsonConvert<LoginDataLocation> {
	String country;
	dynamic province;
	dynamic city;
	dynamic district;
}

class LoginDataCountry with JsonConvert<LoginDataCountry> {
	String zhName;
	String enName;
	String areaCode;
	String language;
	String localCurrency;
	int sort;
}
