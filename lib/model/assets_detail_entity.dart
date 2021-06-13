import 'package:hibi/generated/json/base/json_convert_content.dart';

class AssetsDetailEntity with JsonConvert<AssetsDetailEntity> {
	int code;
	String message;
	AssetsDetailData data;
}

class AssetsDetailData with JsonConvert<AssetsDetailData> {
	dynamic accountTypeEnum;
	double totalAssets;
	double availableBalance;
	double blockedBalance;
	double convertIntoCNY;
	List<AssetsDetailDataCoinParticularsList> coinParticularsList;
	double leverDealGold;
	double systemLockBalance;
}

class AssetsDetailDataCoinParticularsList with JsonConvert<AssetsDetailDataCoinParticularsList> {
	String accountTypeEnum;
	double totalAssets;
	double availableBalance;
	double blockedBalance;
	double convertIntoCNY;
	List<dynamic> coinParticularsList;
	double leverDealGold;
	double systemLockBalance;
}
