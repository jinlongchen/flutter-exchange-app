import 'package:hibi/model/wallet_entity.dart';

walletEntityFromJson(WalletEntity data, Map<String, dynamic> json) {
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
		data.data = new List<WalletData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new WalletData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> walletEntityToJson(WalletEntity entity) {
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
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

walletDataFromJson(WalletData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['coin'] != null) {
		data.coin = new WalletDataCoin().fromJson(json['coin']);
	}
	if (json['balance'] != null) {
		data.balance = json['balance']?.toInt();
	}
	if (json['frozenBalance'] != null) {
		data.frozenBalance = json['frozenBalance']?.toInt();
	}
	if (json['toReleased'] != null) {
		data.toReleased = json['toReleased'];
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

Map<String, dynamic> walletDataToJson(WalletData entity) {
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

walletDataCoinFromJson(WalletDataCoin data, Map<String, dynamic> json) {
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
		data.cnyRate = json['cnyRate']?.toDouble();
	}
	if (json['maxTxFee'] != null) {
		data.maxTxFee = json['maxTxFee']?.toDouble();
	}
	if (json['usdRate'] != null) {
		data.usdRate = json['usdRate']?.toDouble();
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

Map<String, dynamic> walletDataCoinToJson(WalletDataCoin entity) {
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