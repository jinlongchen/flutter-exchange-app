import 'package:hibi/generated/json/base/json_convert_content.dart';

class PyramidPoolEntity with JsonConvert<PyramidPoolEntity> {
	int code;
	String message;
	PyramidPoolData data;
}

class PyramidPoolData with JsonConvert<PyramidPoolData> {
	double prizePoolSum;
	double prizePoolAdd;
	int countDown;
	List<PyramidPoolDataSpillCloseDTOList> spillCloseDTOList;
	PyramidPoolDataPrizeAllocationProportionDTO prizeAllocationProportionDTO;
}

class PyramidPoolDataSpillCloseDTOList with JsonConvert<PyramidPoolDataSpillCloseDTOList> {
	int memberId;
	String userName;
	double closeNum;
}

class PyramidPoolDataPrizeAllocationProportionDTO with JsonConvert<PyramidPoolDataPrizeAllocationProportionDTO> {
	String prizeAllocationProportionFirst;
	String prizeAllocationProportionTwo;
	String prizeAllocationProportionThree;
	String prizeAllocationProportionFour;
	String prizeAllocationProportionFive;
}
