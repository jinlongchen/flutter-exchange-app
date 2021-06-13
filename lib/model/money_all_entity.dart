import 'package:hibi/generated/json/base/json_convert_content.dart';

class MoneyAllEntity with JsonConvert<MoneyAllEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	MoneyAllData data;
}

class MoneyAllData with JsonConvert<MoneyAllData> {
	MoneyAllDataCoinAcount coinAcount;
	MoneyAllDataPurchasecAcount purchasecAcount;
	MoneyAllDataCalcuaAccount calcuaAccount;
}

class MoneyAllDataCoinAcount with JsonConvert<MoneyAllDataCoinAcount> {
	double cnyTotal;
	double usdTotal;
	List<MoneyAllDataCoinAcountData> data;
}

class MoneyAllDataCoinAcountData with JsonConvert<MoneyAllDataCoinAcountData> {
	int id;
	int memberId;
	MoneyAllDataCoinAcountDataCoin coin;
	double balance;
	int frozenBalance;
	int toReleased;
	String address;
	int version;
	int isLock;
	dynamic memo;
}

class MoneyAllDataCoinAcountDataCoin with JsonConvert<MoneyAllDataCoinAcountDataCoin> {
	String name;
	String nameCn;
	String unit;
	int status;
	double minTxFee;
	int cnyRate;
	double maxTxFee;
	int usdRate;
	int enableRpc;
	int sort;
	int canWithdraw;
	int canRecharge;
	int canTransfer;
	int canAutoWithdraw;
	double withdrawThreshold;
	int minWithdrawAmount;
	int maxWithdrawAmount;
	int minRechargeAmount;
	int isPlatformCoin;
	bool hasLegal;
	dynamic allBalance;
	String coldWalletAddress;
	dynamic hotAllBalance;
	dynamic blockHeight;
	double minerFee;
	int withdrawScale;
	String infolink;
	String information;
	int accountType;
	String depositAddress;
}

class MoneyAllDataPurchasecAcount with JsonConvert<MoneyAllDataPurchasecAcount> {
	int cnyTotal;
	int usdTotal;
	List<MoneyAllDataPurchasecAcountData> data;
}

class MoneyAllDataPurchasecAcountData with JsonConvert<MoneyAllDataPurchasecAcountData> {
	dynamic username;
	dynamic email;
	dynamic mobilePhone;
	dynamic startTime;
	dynamic endTime;
	int id;
	int memberId;
	String currencyId;
	double balance;
	int lockBalance;
	int systemLockBalance;
	int onlineBalance;
	int status;
	int putStatus;
	int isExist;
	double leverDealGold;
	String createTime;
	String updateTime;
}

class MoneyAllDataCalcuaAccount with JsonConvert<MoneyAllDataCalcuaAccount> {
	int cnyTotal;
	int usdTotal;
	List<MoneyAllDataCalcuaAccountData> data;
}

class MoneyAllDataCalcuaAccountData with JsonConvert<MoneyAllDataCalcuaAccountData> {
	String username;
	dynamic email;
	String mobilePhone;
	dynamic startTime;
	dynamic endTime;
	int id;
	int memberId;
	String currencyId;
	double balance;
	int lockBalance;
	int systemLockBalance;
	int onlineBalance;
	int mirror;
	int status;
	int putStatus;
	int isExist;
	int days;
	dynamic continuousPositionRecord;
	int activity;
	String createTime;
	String updateTime;
	dynamic activityExpireTime;
	dynamic registerNumber;
	dynamic inviteNumber;
	dynamic communityNumber;
	dynamic continuedNumber;
	dynamic activityNumber;
	dynamic totalMirror;
}
