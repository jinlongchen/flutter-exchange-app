import 'package:hibi/model/pocs_info_entity.dart';

pocsInfoEntityFromJson(PocsInfoEntity data, Map<String, dynamic> json) {
	if (json['content'] != null) {
		data.content = json['content'];
	}
	if (json['totalElements'] != null) {
		data.totalElements = json['totalElements']?.toInt();
	}
	if (json['totalPages'] != null) {
		data.totalPages = json['totalPages']?.toInt();
	}
	if (json['last'] != null) {
		data.last = json['last'];
	}
	if (json['number'] != null) {
		data.number = json['number']?.toInt();
	}
	if (json['size'] != null) {
		data.size = json['size']?.toInt();
	}
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new PocsInfoData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pocsInfoEntityToJson(PocsInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['content'] = entity.content;
	data['totalElements'] = entity.totalElements;
	data['totalPages'] = entity.totalPages;
	data['last'] = entity.last;
	data['number'] = entity.number;
	data['size'] = entity.size;
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pocsInfoDataFromJson(PocsInfoData data, Map<String, dynamic> json) {
	if (json['purchaseStartTime'] != null) {
		data.purchaseStartTime = json['purchaseStartTime']?.toString();
	}
	if (json['everyDayStartTime'] != null) {
		data.everyDayStartTime = json['everyDayStartTime']?.toString();
	}
	if (json['everyDayEndTime'] != null) {
		data.everyDayEndTime = json['everyDayEndTime']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['countdown'] != null) {
		data.countdown = json['countdown']?.toInt();
	}
	if (json['purchaseCurrencyId'] != null) {
		data.purchaseCurrencyId = json['purchaseCurrencyId']?.toString();
	}
	if (json['purchaseCurrencyName'] != null) {
		data.purchaseCurrencyName = json['purchaseCurrencyName']?.toString();
	}
	if (json['payCurrencyId'] != null) {
		data.payCurrencyId = json['payCurrencyId']?.toString();
	}
	if (json['payCurrencyName'] != null) {
		data.payCurrencyName = json['payCurrencyName']?.toString();
	}
	if (json['thisId'] != null) {
		data.thisId = json['thisId']?.toInt();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['totalNumber'] != null) {
		data.totalNumber = json['totalNumber']?.toDouble();
	}
	if (json['everyDayNumber'] != null) {
		data.everyDayNumber = json['everyDayNumber']?.toDouble();
	}
	if (json['discount'] != null) {
		data.discount = json['discount']?.toString();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toDouble();
	}
	if (json['averagePrice'] != null) {
		data.averagePrice = json['averagePrice']?.toDouble();
	}
	if (json['expectedPurchaseNumber'] != null) {
		data.expectedPurchaseNumber = json['expectedPurchaseNumber']?.toString();
	}
	if (json['aboutUSDTMoney'] != null) {
		data.aboutUSDTMoney = json['aboutUSDTMoney']?.toDouble();
	}
	if (json['nowPurchasePrice'] != null) {
		data.nowPurchasePrice = json['nowPurchasePrice']?.toString();
	}
	if (json['nowDiscount'] != null) {
		data.nowDiscount = json['nowDiscount']?.toString();
	}
	if (json['purchaseMoney'] != null) {
		data.purchaseMoney = json['purchaseMoney']?.toDouble();
	}
	if (json['myMirrorCalcula'] != null) {
		data.myMirrorCalcula = json['myMirrorCalcula']?.toString();
	}
	if (json['myRealCalcula'] != null) {
		data.myRealCalcula = json['myRealCalcula']?.toString();
	}
	if (json['myAllCalcula'] != null) {
		data.myAllCalcula = json['myAllCalcula']?.toString();
	}
	if (json['atPresentCalculate'] != null) {
		data.atPresentCalculate = new PocsInfoDataAtPresentCalculate().fromJson(json['atPresentCalculate']);
	}
	return data;
}

Map<String, dynamic> pocsInfoDataToJson(PocsInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['purchaseStartTime'] = entity.purchaseStartTime;
	data['everyDayStartTime'] = entity.everyDayStartTime;
	data['everyDayEndTime'] = entity.everyDayEndTime;
	data['status'] = entity.status;
	data['countdown'] = entity.countdown;
	data['purchaseCurrencyId'] = entity.purchaseCurrencyId;
	data['purchaseCurrencyName'] = entity.purchaseCurrencyName;
	data['payCurrencyId'] = entity.payCurrencyId;
	data['payCurrencyName'] = entity.payCurrencyName;
	data['thisId'] = entity.thisId;
	data['content'] = entity.content;
	data['name'] = entity.name;
	data['totalNumber'] = entity.totalNumber;
	data['everyDayNumber'] = entity.everyDayNumber;
	data['discount'] = entity.discount;
	data['price'] = entity.price;
	data['averagePrice'] = entity.averagePrice;
	data['expectedPurchaseNumber'] = entity.expectedPurchaseNumber;
	data['aboutUSDTMoney'] = entity.aboutUSDTMoney;
	data['nowPurchasePrice'] = entity.nowPurchasePrice;
	data['nowDiscount'] = entity.nowDiscount;
	data['purchaseMoney'] = entity.purchaseMoney;
	data['myMirrorCalcula'] = entity.myMirrorCalcula;
	data['myRealCalcula'] = entity.myRealCalcula;
	data['myAllCalcula'] = entity.myAllCalcula;
	if (entity.atPresentCalculate != null) {
		data['atPresentCalculate'] = entity.atPresentCalculate.toJson();
	}
	return data;
}

pocsInfoDataAtPresentCalculateFromJson(PocsInfoDataAtPresentCalculate data, Map<String, dynamic> json) {
	if (json['allCalcula'] != null) {
		data.allCalcula = json['allCalcula']?.toString();
	}
	if (json['realCalcula'] != null) {
		data.realCalcula = json['realCalcula']?.toString();
	}
	if (json['mirrorCalcula'] != null) {
		data.mirrorCalcula = json['mirrorCalcula']?.toString();
	}
	if (json['calculaWallet'] != null) {
		data.calculaWallet = json['calculaWallet']?.toString();
	}
	if (json['purchaseWallet'] != null) {
		data.purchaseWallet = json['purchaseWallet']?.toString();
	}
	if (json['continuous'] != null) {
		data.continuous = json['continuous']?.toString();
	}
	if (json['promote'] != null) {
		data.promote = json['promote']?.toString();
	}
	if (json['community'] != null) {
		data.community = json['community']?.toString();
	}
	if (json['regist'] != null) {
		data.regist = json['regist']?.toString();
	}
	if (json['activity'] != null) {
		data.activity = json['activity']?.toString();
	}
	if (json['finance'] != null) {
		data.finance = json['finance']?.toString();
	}
	return data;
}

Map<String, dynamic> pocsInfoDataAtPresentCalculateToJson(PocsInfoDataAtPresentCalculate entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['allCalcula'] = entity.allCalcula;
	data['realCalcula'] = entity.realCalcula;
	data['mirrorCalcula'] = entity.mirrorCalcula;
	data['calculaWallet'] = entity.calculaWallet;
	data['purchaseWallet'] = entity.purchaseWallet;
	data['continuous'] = entity.continuous;
	data['promote'] = entity.promote;
	data['community'] = entity.community;
	data['regist'] = entity.regist;
	data['activity'] = entity.activity;
	data['finance'] = entity.finance;
	return data;
}