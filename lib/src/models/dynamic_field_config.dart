import 'dart:convert';
import 'package:flutter/services.dart';

class DynamicFieldOption {
  final String label;
  final dynamic value;
  const DynamicFieldOption({required this.label, required this.value});

  factory DynamicFieldOption.fromJson(Map<String, dynamic> json) {
    return DynamicFieldOption(
      label: json['label'] as String,
      value: json['value'],
    );
  }
}

class DynamicFieldConfig {
  final int id;
  final String fieldName;
  final int fieldType;
  final int? validationType;
  final bool isMandatory;
  final String? stringValueList;
  final List<dynamic>? value;
  final List<DynamicFieldOption>? options;
  final String? requiredFieldMessage;
  final String? placeholder;

  const DynamicFieldConfig({
    required this.id,
    required this.fieldName,
    required this.fieldType,
    this.validationType,
    this.isMandatory = false,
    this.stringValueList,
    this.value,
    this.options,
    this.requiredFieldMessage,
    this.placeholder,
  });

  factory DynamicFieldConfig.fromJson(Map<String, dynamic> json) {
    return DynamicFieldConfig(
      id: json['id'] as int,
      fieldName: json['fieldName'] as String,
      fieldType: json['fieldType'] as int,
      validationType: json['validationType'] as int?,
      isMandatory: json['isMandatory'] ?? false,
      stringValueList: json['stringValueList'] as String?,
      value: json['value'] as List<dynamic>?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => DynamicFieldOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      requiredFieldMessage: json['requiredFieldMessage'] as String?,
      placeholder: json['placeholder'] as String?,
    );
  }

  static Future<List<DynamicFieldConfig>> loadFromAssets(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => DynamicFieldConfig.fromJson(e as Map<String, dynamic>)).toList();
  }
}
