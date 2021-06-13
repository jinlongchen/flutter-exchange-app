import 'package:hibi/generated/json/base/json_convert_content.dart';

class MoneyListEntity with JsonConvert<MoneyListEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	MoneyListData data;
}

class MoneyListData with JsonConvert<MoneyListData> {
	double cnyTotal;
	double usdTotal;
	double usdTotalSum;
	double cnyTotalSum;
	List<MoneyListDataData> data;
}

class MoneyListDataData with JsonConvert<MoneyListDataData> {
	int id;
	int memberId;
	MoneyListDataDataCoin coin;
	double balance;
	int frozenBalance;
	int toReleased;
	String address;
	int version;
	int isLock;
	double totalSum;
	dynamic memo;
}

class MoneyListDataDataCoin with JsonConvert<MoneyListDataDataCoin> {
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
	String chargeMoneyHint;
	String mentionMoneyHint;
}
