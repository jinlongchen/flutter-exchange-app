import 'package:hibi/model/money_all_entity.dart';

moneyAllEntityFromJson(MoneyAllEntity data, Map<String, dynamic> json) {
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
		data.data = new MoneyAllData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> moneyAllEntityToJson(MoneyAllEntity entity) {
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

moneyAllDataFromJson(MoneyAllData data, Map<String, dynamic> json) {
	if (json['coinAcount'] != null) {
		data.coinAcount = new MoneyAllDataCoinAcount().fromJson(json['coinAcount']);
	}
	if (json['purchasecAcount'] != null) {
		data.purchasecAcount = new MoneyAllDataPurchasecAcount().fromJson(json['purchasecAcount']);
	}
	if (json['calcuaAccount'] != null) {
		data.calcuaAccount = new MoneyAllDataCalcuaAccount().fromJson(json['calcuaAccount']);
	}
	return data;
}

Map<String, dynamic> moneyAllDataToJson(MoneyAllData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.coinAcount != null) {
		data['coinAcount'] = entity.coinAcount.toJson();
	}
	if (entity.purchasecAcount != null) {
		data['purchasecAcount'] = entity.purchasecAcount.toJson();
	}
	if (entity.calcuaAccount != null) {
		data['calcuaAccount'] = entity.calcuaAccount.toJson();
	}
	return data;
}

moneyAllDataCoinAcountFromJson(MoneyAllDataCoinAcount data, Map<String, dynamic> json) {
	if (json['cnyTotal'] != null) {
		data.cnyTotal = json['cnyTotal']?.toDouble();
	}
	if (json['usdTotal'] != null) {
		data.usdTotal = json['usdTotal']?.toDouble();
	}
	if (json['data'] != null) {
		data.data = new List<MoneyAllDataCoinAcountData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new MoneyAllDataCoinAcountData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> moneyAllDataCoinAcountToJson(MoneyAllDataCoinAcount entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cnyTotal'] = entity.cnyTotal;
	data['usdTotal'] = entity.usdTotal;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

moneyAllDataCoinAcountDataFromJson(MoneyAllDataCoinAcountData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['coin'] != null) {
		data.coin = new MoneyAllDataCoinAcountDataCoin().fromJson(json['coin']);
	}
	if (json['balance'] != null) {
		data.balance = json['balance']?.toDouble();
	}
	if (json['frozenBalance'] != null) {
		data.frozenBalance = json['frozenBalance']?.toInt();
	}
	if (json['toReleased'] != null) {
		data.toReleased = json['toReleased']?.toInt();
	}
	if (json['address'] != null) {
		data.address = json['address']?.toString();
	}
	if (json['version'] != null) {
		data.version = json['version']?.toInt();
	}
	if (json['isLock'] != null) {
		data.isLock = json['isLock']?.toInt();
	}
	if (json['memo'] != null) {
		data.memo = json['memo'];
	}
	return data;
}

Map<String, dynamic> moneyAllDataCoinAcountDataToJson(MoneyAllDataCoinAcountData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['memberId'] = entity.memberId;
	if (entity.coin != null) {
		data['coin'] = entity.coin.toJson();
	}
	data['balance'] = entity.balance;
	data['frozenBalance'] = entity.frozenBalance;
	data['toReleased'] = entity.toReleased;
	data['address'] = entity.address;
	data['version'] = entity.version;
	data['isLock'] = entity.isLock;
	data['memo'] = entity.memo;
	return data;
}

moneyAllDataCoinAcountDataCoinFromJson(MoneyAllDataCoinAcountDataCoin data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['nameCn'] != null) {
		data.nameCn = json['nameCn']?.toString();
	}
	if (json['unit'] != null) {
		data.unit = json['unit']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['minTxFee'] != null) {
		data.minTxFee = json['minTxFee']?.toDouble();
	}
	if (json['cnyRate'] != null) {
		data.cnyRate = json['cnyRate']?.toInt();
	}
	if (json['maxTxFee'] != null) {
		data.maxTxFee = json['maxTxFee']?.toDouble();
	}
	if (json['usdRate'] != null) {
		data.usdRate = json['usdRate']?.toInt();
	}
	if (json['enableRpc'] != null) {
		data.enableRpc = json['enableRpc']?.toInt();
	}
	if (json['sort'] != null) {
		data.sort = json['sort']?.toInt();
	}
	if (json['canWithdraw'] != null) {
		data.canWithdraw = json['canWithdraw']?.toInt();
	}
	if (json['canRecharge'] != null) {
		data.canRecharge = json['canRecharge']?.toInt();
	}
	if (json['canTransfer'] != null) {
		data.canTransfer = json['canTransfer']?.toInt();
	}
	if (json['canAutoWithdraw'] != null) {
		data.canAutoWithdraw = json['canAutoWithdraw']?.toInt();
	}
	if (json['withdrawThreshold'] != null) {
		data.withdrawThreshold = json['withdrawThreshold']?.toDouble();
	}
	if (json['minWithdrawAmount'] != null) {
		data.minWithdrawAmount = json['minWithdrawAmount']?.toInt();
	}
	if (json['maxWithdrawAmount'] != null) {
		data.maxWithdrawAmount = json['maxWithdrawAmount']?.toInt();
	}
	if (json['minRechargeAmount'] != null) {
		data.minRechargeAmount = json['minRechargeAmount']?.toInt();
	}
	if (json['isPlatformCoin'] != null) {
		data.isPlatformCoin = json['isPlatformCoin']?.toInt();
	}
	if (json['hasLegal'] != null) {
		data.hasLegal = json['hasLegal'];
	}
	if (json['allBalance'] != null) {
		data.allBalance = json['allBalance'];
	}
	if (json['coldWalletAddress'] != null) {
		data.coldWalletAddress = json['coldWalletAddress']?.toString();
	}
	if (json['hotAllBalance'] != null) {
		data.hotAllBalance = json['hotAllBalance'];
	}
	if (json['blockHeight'] != null) {
		data.blockHeight = json['blockHeight'];
	}
	if (json['minerFee'] != null) {
		data.minerFee = json['minerFee']?.toDouble();
	}
	if (json['withdrawScale'] != null) {
		data.withdrawScale = json['withdrawScale']?.toInt();
	}
	if (json['infolink'] != null) {
		data.infolink = json['infolink']?.toString();
	}
	if (json['information'] != null) {
		data.information = json['information']?.toString();
	}
	if (json['accountType'] != null) {
		data.accountType = json['accountType']?.toInt();
	}
	if (json['depositAddress'] != null) {
		data.depositAddress = json['depositAddress']?.toString();
	}
	return data;
}

Map<String, dynamic> moneyAllDataCoinAcountDataCoinToJson(MoneyAllDataCoinAcountDataCoin entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['nameCn'] = entity.nameCn;
	data['unit'] = entity.unit;
	data['status'] = entity.status;
	data['minTxFee'] = entity.minTxFee;
	data['cnyRate'] = entity.cnyRate;
	data['maxTxFee'] = entity.maxTxFee;
	data['usdRate'] = entity.usdRate;
	data['enableRpc'] = entity.enableRpc;
	data['sort'] = entity.sort;
	data['canWithdraw'] = entity.canWithdraw;
	data['canRecharge'] = entity.canRecharge;
	data['canTransfer'] = entity.canTransfer;
	data['canAutoWithdraw'] = entity.canAutoWithdraw;
	data['withdrawThreshold'] = entity.withdrawThreshold;
	data['minWithdrawAmount'] = entity.minWithdrawAmount;
	data['maxWithdrawAmount'] = entity.maxWithdrawAmount;
	data['minRechargeAmount'] = entity.minRechargeAmount;
	data['isPlatformCoin'] = entity.isPlatformCoin;
	data['hasLegal'] = entity.hasLegal;
	data['allBalance'] = entity.allBalance;
	data['coldWalletAddress'] = entity.coldWalletAddress;
	data['hotAllBalance'] = entity.hotAllBalance;
	data['blockHeight'] = entity.blockHeight;
	data['minerFee'] = entity.minerFee;
	data['withdrawScale'] = entity.withdrawScale;
	data['infolink'] = entity.infolink;
	data['information'] = entity.information;
	data['accountType'] = entity.accountType;
	data['depositAddress'] = entity.depositAddress;
	return data;
}

moneyAllDataPurchasecAcountFromJson(MoneyAllDataPurchasecAcount data, Map<String, dynamic> json) {
	if (json['cnyTotal'] != null) {
		data.cnyTotal = json['cnyTotal']?.toInt();
	}
	if (json['usdTotal'] != null) {
		data.usdTotal = json['usdTotal']?.toInt();
	}
	if (json['data'] != null) {
		data.data = new List<MoneyAllDataPurchasecAcountData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new MoneyAllDataPurchasecAcountData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> moneyAllDataPurchasecAcountToJson(MoneyAllDataPurchasecAcount entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cnyTotal'] = entity.cnyTotal;
	data['usdTotal'] = entity.usdTotal;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

moneyAllDataPurchasecAcountDataFromJson(MoneyAllDataPurchasecAcountData data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username'];
	}
	if (json['email'] != null) {
		data.email = json['email'];
	}
	if (json['mobilePhone'] != null) {
		data.mobilePhone = json['mobilePhone'];
	}
	if (json['startTime'] != null) {
		data.startTime = json['startTime'];
	}
	if (json['endTime'] != null) {
		data.endTime = json['endTime'];
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['currencyId'] != null) {
		data.currencyId = json['currencyId']?.toString();
	}
	if (json['balance'] != null) {
		data.balance = json['balance']?.toDouble();
	}
	if (json['lockBalance'] != null) {
		data.lockBalance = json['lockBalance']?.toInt();
	}
	if (json['systemLockBalance'] != null) {
		data.systemLockBalance = json['systemLockBalance']?.toInt();
	}
	if (json['onlineBalance'] != null) {
		data.onlineBalance = json['onlineBalance']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['putStatus'] != null) {
		data.putStatus = json['putStatus']?.toInt();
	}
	if (json['isExist'] != null) {
		data.isExist = json['isExist']?.toInt();
	}
	if (json['leverDealGold'] != null) {
		data.leverDealGold = json['leverDealGold']?.toDouble();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime']?.toString();
	}
	return data;
}

Map<String, dynamic> moneyAllDataPurchasecAcountDataToJson(MoneyAllDataPurchasecAcountData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['email'] = entity.email;
	data['mobilePhone'] = entity.mobilePhone;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['id'] = entity.id;
	data['memberId'] = entity.memberId;
	data['currencyId'] = entity.currencyId;
	data['balance'] = entity.balance;
	data['lockBalance'] = entity.lockBalance;
	data['systemLockBalance'] = entity.systemLockBalance;
	data['onlineBalance'] = entity.onlineBalance;
	data['status'] = entity.status;
	data['putStatus'] = entity.putStatus;
	data['isExist'] = entity.isExist;
	data['leverDealGold'] = entity.leverDealGold;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	return data;
}

moneyAllDataCalcuaAccountFromJson(MoneyAllDataCalcuaAccount data, Map<String, dynamic> json) {
	if (json['cnyTotal'] != null) {
		data.cnyTotal = json['cnyTotal']?.toInt();
	}
	if (json['usdTotal'] != null) {
		data.usdTotal = json['usdTotal']?.toInt();
	}
	if (json['data'] != null) {
		data.data = new List<MoneyAllDataCalcuaAccountData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new MoneyAllDataCalcuaAccountData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> moneyAllDataCalcuaAccountToJson(MoneyAllDataCalcuaAccount entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cnyTotal'] = entity.cnyTotal;
	data['usdTotal'] = entity.usdTotal;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

moneyAllDataCalcuaAccountDataFromJson(MoneyAllDataCalcuaAccountData data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['email'] != null) {
		data.email = json['email'];
	}
	if (json['mobilePhone'] != null) {
		data.mobilePhone = json['mobilePhone']?.toString();
	}
	if (json['startTime'] != null) {
		data.startTime = json['startTime'];
	}
	if (json['endTime'] != null) {
		data.endTime = json['endTime'];
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['currencyId'] != null) {
		data.currencyId = json['currencyId']?.toString();
	}
	if (json['balance'] != null) {
		data.balance = json['balance']?.toDouble();
	}
	if (json['lockBalance'] != null) {
		data.lockBalance = json['lockBalance']?.toInt();
	}
	if (json['systemLockBalance'] != null) {
		data.systemLockBalance = json['systemLockBalance']?.toInt();
	}
	if (json['onlineBalance'] != null) {
		data.onlineBalance = json['onlineBalance']?.toInt();
	}
	if (json['mirror'] != null) {
		data.mirror = json['mirror']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['putStatus'] != null) {
		data.putStatus = json['putStatus']?.toInt();
	}
	if (json['isExist'] != null) {
		data.isExist = json['isExist']?.toInt();
	}
	if (json['days'] != null) {
		data.days = json['days']?.toInt();
	}
	if (json['continuousPositionRecord'] != null) {
		data.continuousPositionRecord = json['continuousPositionRecord'];
	}
	if (json['activity'] != null) {
		data.activity = json['activity']?.toInt();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime']?.toString();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime']?.toString();
	}
	if (json['activityExpireTime'] != null) {
		data.activityExpireTime = json['activityExpireTime'];
	}
	if (json['registerNumber'] != null) {
		data.registerNumber = json['registerNumber'];
	}
	if (json['inviteNumber'] != null) {
		data.inviteNumber = json['inviteNumber'];
	}
	if (json['communityNumber'] != null) {
		data.communityNumber = json['communityNumber'];
	}
	if (json['continuedNumber'] != null) {
		data.continuedNumber = json['continuedNumber'];
	}
	if (json['activityNumber'] != null) {
		data.activityNumber = json['activityNumber'];
	}
	if (json['totalMirror'] != null) {
		data.totalMirror = json['totalMirror'];
	}
	return data;
}

Map<String, dynamic> moneyAllDataCalcuaAccountDataToJson(MoneyAllDataCalcuaAccountData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['email'] = entity.email;
	data['mobilePhone'] = entity.mobilePhone;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['id'] = entity.id;
	data['memberId'] = entity.memberId;
	data['currencyId'] = entity.currencyId;
	data['balance'] = entity.balance;
	data['lockBalance'] = entity.lockBalance;
	data['systemLockBalance'] = entity.systemLockBalance;
	data['onlineBalance'] = entity.onlineBalance;
	data['mirror'] = entity.mirror;
	data['status'] = entity.status;
	data['putStatus'] = entity.putStatus;
	data['isExist'] = entity.isExist;
	data['days'] = entity.days;
	data['continuousPositionRecord'] = entity.continuousPositionRecord;
	data['activity'] = entity.activity;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['activityExpireTime'] = entity.activityExpireTime;
	data['registerNumber'] = entity.registerNumber;
	data['inviteNumber'] = entity.inviteNumber;
	data['communityNumber'] = entity.communityNumber;
	data['continuedNumber'] = entity.continuedNumber;
	data['activityNumber'] = entity.activityNumber;
	data['totalMirror'] = entity.totalMirror;
	return data;
}