import 'package:hibi/model/assets_detail_entity.dart';

assetsDetailEntityFromJson(AssetsDetailEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new AssetsDetailData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> assetsDetailEntityToJson(AssetsDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

assetsDetailDataFromJson(AssetsDetailData data, Map<String, dynamic> json) {
	if (json['accountTypeEnum'] != null) {
		data.accountTypeEnum = json['accountTypeEnum'];
	}
	if (json['totalAssets'] != null) {
		data.totalAssets = json['totalAssets']?.toDouble();
	}
	if (json['availableBalance'] != null) {
		data.availableBalance = json['availableBalance']?.toDouble();
	}
	if (json['blockedBalance'] != null) {
		data.blockedBalance = json['blockedBalance']?.toDouble();
	}
	if (json['convertIntoCNY'] != null) {
		data.convertIntoCNY = json['convertIntoCNY']?.toDouble();
	}
	if (json['coinParticularsList'] != null) {
		data.coinParticularsList = new List<AssetsDetailDataCoinParticularsList>();
		(json['coinParticularsList'] as List).forEach((v) {
			data.coinParticularsList.add(new AssetsDetailDataCoinParticularsList().fromJson(v));
		});
	}
	if (json['leverDealGold'] != null) {
		data.leverDealGold = json['leverDealGold']?.toDouble();
	}
	if (json['systemLockBalance'] != null) {
		data.systemLockBalance = json['systemLockBalance']?.toDouble();
	}
	return data;
}

Map<String, dynamic> assetsDetailDataToJson(AssetsDetailData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['accountTypeEnum'] = entity.accountTypeEnum;
	data['totalAssets'] = entity.totalAssets;
	data['availableBalance'] = entity.availableBalance;
	data['blockedBalance'] = entity.blockedBalance;
	data['convertIntoCNY'] = entity.convertIntoCNY;
	if (entity.coinParticularsList != null) {
		data['coinParticularsList'] =  entity.coinParticularsList.map((v) => v.toJson()).toList();
	}
	data['leverDealGold'] = entity.leverDealGold;
	data['systemLockBalance'] = entity.systemLockBalance;
	return data;
}

assetsDetailDataCoinParticularsListFromJson(AssetsDetailDataCoinParticularsList data, Map<String, dynamic> json) {
	if (json['accountTypeEnum'] != null) {
		data.accountTypeEnum = json['accountTypeEnum']?.toString();
	}
	if (json['totalAssets'] != null) {
		data.totalAssets = json['totalAssets']?.toDouble();
	}
	if (json['availableBalance'] != null) {
		data.availableBalance = json['availableBalance']?.toDouble();
	}
	if (json['blockedBalance'] != null) {
		data.blockedBalance = json['blockedBalance']?.toDouble();
	}
	if (json['convertIntoCNY'] != null) {
		data.convertIntoCNY = json['convertIntoCNY']?.toDouble();
	}
	if (json['coinParticularsList'] != null) {
		data.coinParticularsList = new List<dynamic>();
		data.coinParticularsList.addAll(json['coinParticularsList']);
	}
	if (json['leverDealGold'] != null) {
		data.leverDealGold = json['leverDealGold']?.toDouble();
	}
	if (json['systemLockBalance'] != null) {
		data.systemLockBalance = json['systemLockBalance']?.toDouble();
	}
	return data;
}

Map<String, dynamic> assetsDetailDataCoinParticularsListToJson(AssetsDetailDataCoinParticularsList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['accountTypeEnum'] = entity.accountTypeEnum;
	data['totalAssets'] = entity.totalAssets;
	data['availableBalance'] = entity.availableBalance;
	data['blockedBalance'] = entity.blockedBalance;
	data['convertIntoCNY'] = entity.convertIntoCNY;
	if (entity.coinParticularsList != null) {
		data['coinParticularsList'] =  [];
	}
	data['leverDealGold'] = entity.leverDealGold;
	data['systemLockBalance'] = entity.systemLockBalance;
	return data;
}