import 'package:hibi/generated/json/base/json_convert_content.dart';

class AssetsBalanceEntity with JsonConvert<AssetsBalanceEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	List<AssetsBalanceData> data;
}

class AssetsBalanceData with JsonConvert<AssetsBalanceData> {
	int id;
	int memberId;
	AssetsBalanceDataCoin coin;
	double balance;
	double frozenBalance;
	int toReleased;
	String address;
	int version;
	int isLock;
	dynamic memo;
	dynamic totalSum;
}

class AssetsBalanceDataCoin with JsonConvert<AssetsBalanceDataCoin> {
	String name;
	String nameCn;
	String unit;
	int status;
	double minTxFee;
	double cnyRate;
	double maxTxFee;
	double usdRate;
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
