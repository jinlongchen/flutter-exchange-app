import 'package:hibi/model/pyramid_product_entity.dart';

pyramidProductEntityFromJson(PyramidProductEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<PyramidProductData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new PyramidProductData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> pyramidProductEntityToJson(PyramidProductEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['message'] = entity.message;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

pyramidProductDataFromJson(PyramidProductData data, Map<String, dynamic> json) {
	if (json['level'] != null) {
		data.level = json['level']?.toString();
	}
	if (json['mealNum'] != null) {
		data.mealNum = json['mealNum']?.toInt();
	}
	if (json['currencyId'] != null) {
		data.currencyId = json['currencyId']?.toString();
	}
	if (json['yield'] != null) {
		data.xYield = json['yield']?.toDouble();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['maxNum'] != null) {
		data.maxNum = json['maxNum']?.toInt();
	}
	if (json['period'] != null) {
		data.period = json['period']?.toInt();
	}
	return data;
}

Map<String, dynamic> pyramidProductDataToJson(PyramidProductData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['level'] = entity.level;
	data['mealNum'] = entity.mealNum;
	data['currencyId'] = entity.currencyId;
	data['yield'] = entity.xYield;
	data['status'] = entity.status;
	data['maxNum'] = entity.maxNum;
	data['period'] = entity.period;
	return data;
}