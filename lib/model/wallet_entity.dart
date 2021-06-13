import 'package:hibi/generated/json/base/json_convert_content.dart';

class WalletEntity with JsonConvert<WalletEntity> {
	dynamic content;
	int totalElements;
	int totalPages;
	bool last;
	int number;
	int size;
	int code;
	String message;
	List<WalletData> data;
}

class WalletData with JsonConvert<WalletData> {
	int id;
	int memberId;
	WalletDataCoin coin;
	int balance;
	int frozenBalance;
	dynamic toReleased;
	String address;
	int version;
	int isLock;
	dynamic memo;
}

class WalletDataCoin with JsonConvert<WalletDataCoin> {
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
