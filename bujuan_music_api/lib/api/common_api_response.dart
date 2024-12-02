import 'dart:convert';

import '../../generated/json/base/json_convert_content.dart';


class CommonApiResponse<T> {
	int? code;
	T? data;
	String? message;

	CommonApiResponse();

	factory CommonApiResponse.fromJson(Map<String, dynamic> json) => $BaseApiResponseFromJson<T>(json);

	Map<String, dynamic> toJson() => $BaseApiResponseToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

Map<String, dynamic> $BaseApiResponseToJson(CommonApiResponse entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['message'] = entity.message;
	data['data'] = entity.data;
	return data;
}

CommonApiResponse<T> $BaseApiResponseFromJson<T>(Map<String, dynamic> json) {
	final CommonApiResponse<T> apiResponseEntity = CommonApiResponse<T>();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		apiResponseEntity.code = code;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		apiResponseEntity.message = message;
	}
	final T? data = jsonConvert.convert<T>(json['data']);
	if (data != null) {
		apiResponseEntity.data = data;
	}
	return apiResponseEntity;
}
