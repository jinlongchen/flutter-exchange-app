import 'package:hibi/model/pyramid_pool_entity.dart';

pyramidPoolEntityFromJson(PyramidPoolEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new PyramidPoolData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pyramidPoolEntityToJson(PyramidPoolEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pyramidPoolDataFromJson(PyramidPoolData data, Map<String, dynamic> json) {
	if (json['prizePoolSum'] != null) {
		data.prizePoolSum = json['prizePoolSum']?.toDouble();
	}
	if (json['prizePoolAdd'] != null) {
		data.prizePoolAdd = json['prizePoolAdd']?.toDouble();
	}
	if (json['countDown'] != null) {
		data.countDown = json['countDown']?.toInt();
	}
	if (json['spillCloseDTOList'] != null) {
		data.spillCloseDTOList = new List<PyramidPoolDataSpillCloseDTOList>();
		(json['spillCloseDTOList'] as List).forEach((v) {
			data.spillCloseDTOList.add(new PyramidPoolDataSpillCloseDTOList().fromJson(v));
		});
	}
	if (json['prizeAllocationProportionDTO'] != null) {
		data.prizeAllocationProportionDTO = new PyramidPoolDataPrizeAllocationProportionDTO().fromJson(json['prizeAllocationProportionDTO']);
	}
	return data;
}

Map<String, dynamic> pyramidPoolDataToJson(PyramidPoolData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['prizePoolSum'] = entity.prizePoolSum;
	data['prizePoolAdd'] = entity.prizePoolAdd;
	data['countDown'] = entity.countDown;
	if (entity.spillCloseDTOList != null) {
		data['spillCloseDTOList'] =  entity.spillCloseDTOList.map((v) => v.toJson()).toList();
	}
	if (entity.prizeAllocationProportionDTO != null) {
		data['prizeAllocationProportionDTO'] = entity.prizeAllocationProportionDTO.toJson();
	}
	return data;
}

pyramidPoolDataSpillCloseDTOListFromJson(PyramidPoolDataSpillCloseDTOList data, Map<String, dynamic> json) {
	if (json['memberId'] != null) {
		data.memberId = json['memberId']?.toInt();
	}
	if (json['userName'] != null) {
		data.userName = json['userName']?.toString();
	}
	if (json['closeNum'] != null) {
		data.closeNum = json['closeNum']?.toDouble();
	}
	return data;
}

Map<String, dynamic> pyramidPoolDataSpillCloseDTOListToJson(PyramidPoolDataSpillCloseDTOList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['memberId'] = entity.memberId;
	data['userName'] = entity.userName;
	data['closeNum'] = entity.closeNum;
	return data;
}

pyramidPoolDataPrizeAllocationProportionDTOFromJson(PyramidPoolDataPrizeAllocationProportionDTO data, Map<String, dynamic> json) {
	if (json['prizeAllocationProportionFirst'] != null) {
		data.prizeAllocationProportionFirst = json['prizeAllocationProportionFirst']?.toString();
	}
	if (json['prizeAllocationProportionTwo'] != null) {
		data.prizeAllocationProportionTwo = json['prizeAllocationProportionTwo']?.toString();
	}
	if (json['prizeAllocationProportionThree'] != null) {
		data.prizeAllocationProportionThree = json['prizeAllocationProportionThree']?.toString();
	}
	if (json['prizeAllocationProportionFour'] != null) {
		data.prizeAllocationProportionFour = json['prizeAllocationProportionFour']?.toString();
	}
	if (json['prizeAllocationProportionFive'] != null) {
		data.prizeAllocationProportionFive = json['prizeAllocationProportionFive']?.toString();
	}
	return data;
}

Map<String, dynamic> pyramidPoolDataPrizeAllocationProportionDTOToJson(PyramidPoolDataPrizeAllocationProportionDTO entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['prizeAllocationProportionFirst'] = entity.prizeAllocationProportionFirst;
	data['prizeAllocationProportionTwo'] = entity.prizeAllocationProportionTwo;
	data['prizeAllocationProportionThree'] = entity.prizeAllocationProportionThree;
	data['prizeAllocationProportionFour'] = entity.prizeAllocationProportionFour;
	data['prizeAllocationProportionFive'] = entity.prizeAllocationProportionFive;
	return data;
}