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
  final DateTime? minDate;
  final DateTime? maxDate;
  final String? minDateFromField;
  final String? maxDateFromField;
  
  // Advanced Validations
  final int? minLength;
  final int? maxLength;
  final num? minValue;
  final num? maxValue;
  final String? regexPattern;
  
  // Financial & Formatting
  final bool isCurrency;
  final bool allowNegative;
  
  // Identity & Regional
  final bool isSriLankanNIC;
  final bool isSriLankanPhone;
  final bool isSriLankanVehicle;
  
  // Media Limits
  final int? minAttachments;
  final int? maxAttachments;
  
  // Cross-field & Logic
  final String? matchFieldName;
  final String? conditionalShowFieldName;
  final dynamic conditionalShowFieldValue;

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
    this.minDate,
    this.maxDate,
    this.minDateFromField,
    this.maxDateFromField,
    this.minLength,
    this.maxLength,
    this.minValue,
    this.maxValue,
    this.regexPattern,
    this.isCurrency = false,
    this.allowNegative = true,
    this.isSriLankanNIC = false,
    this.isSriLankanPhone = false,
    this.isSriLankanVehicle = false,
    this.minAttachments,
    this.maxAttachments,
    this.matchFieldName,
    this.conditionalShowFieldName,
    this.conditionalShowFieldValue,
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
      minDate: json['minDate'] != null ? DateTime.tryParse(json['minDate'].toString()) : null,
      maxDate: json['maxDate'] != null ? DateTime.tryParse(json['maxDate'].toString()) : null,
      minDateFromField: json['minDateFromField']?.toString(),
      maxDateFromField: json['maxDateFromField']?.toString(),
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
      minValue: json['minValue'] as num?,
      maxValue: json['maxValue'] as num?,
      regexPattern: json['regexPattern'] as String?,
      isCurrency: json['isCurrency'] ?? false,
      allowNegative: json['allowNegative'] ?? true,
      isSriLankanNIC: json['isSriLankanNIC'] ?? false,
      isSriLankanPhone: json['isSriLankanPhone'] ?? false,
      isSriLankanVehicle: json['isSriLankanVehicle'] ?? false,
      minAttachments: json['minAttachments'] as int?,
      maxAttachments: json['maxAttachments'] as int?,
      matchFieldName: json['matchFieldName'] as String?,
      conditionalShowFieldName: json['conditionalShowFieldName'] as String?,
      conditionalShowFieldValue: json['conditionalShowFieldValue'],
    );
  }

  static Future<List<DynamicFieldConfig>> loadFromAssets(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => DynamicFieldConfig.fromJson(e as Map<String, dynamic>)).toList();
  }
}
