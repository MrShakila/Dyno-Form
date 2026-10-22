import 'dart:convert';

import 'package:flutter/services.dart';

import 'dynamic_field_type.dart';

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
  final dynamic id;
  final String fieldName;
  final int fieldType;
  final int? sequence;
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

  // Key tracking & Description
  final String? dataKey;
  final String? description;
  final Map<String, dynamic>? style;
  final Map<String, dynamic>? rawConfig;

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
    this.sequence,
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
    this.dataKey,
    this.description,
    this.style,
    this.rawConfig,
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

  /// Helper getter returning integer ID for backward compatibility
  int get intId =>
      id is int ? id as int : (int.tryParse(id.toString()) ?? id.hashCode);

  /// Strips HTML tags from formatted strings (e.g., `<b>Header</b>` -> `Header`).
  static String stripHtml(String? text) {
    if (text == null || text.isEmpty) return '';
    return text
        .replaceAll(
          RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false),
          '',
        )
        .replaceAll('&amp;', '&')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  factory DynamicFieldConfig.fromJson(Map<String, dynamic> json) {
    // 1. Resolve ID (String or int)
    final dynamic resolvedId =
        json['id'] ??
        json['dataKey'] ??
        json['name'] ??
        DateTime.now().millisecondsSinceEpoch;

    // 2. Resolve Field Name / Label (with HTML cleanup)
    String rawLabel = (json['fieldName'] ?? json['label'] ?? json['name'] ?? '')
        .toString();
    final cleanLabel = stripHtml(rawLabel);
    final fieldName = cleanLabel.isNotEmpty ? cleanLabel : 'Field';

    // 3. Resolve Field Type
    int resolvedType = DynamicFieldType.text.id;
    if (json['fieldType'] is int) {
      resolvedType = json['fieldType'] as int;
    } else if (json['type'] is String) {
      resolvedType = DynamicFieldType.fromString(json['type'] as String).id;
    }

    // 4. Resolve Options (supports both [{label, value}] and simple String lists)
    List<DynamicFieldOption>? resolvedOptions;
    if (json['options'] is List) {
      final optList = json['options'] as List;
      resolvedOptions = optList.map((e) {
        if (e is Map<String, dynamic>) {
          return DynamicFieldOption.fromJson(e);
        } else {
          return DynamicFieldOption(label: e.toString(), value: e);
        }
      }).toList();
    }

    return DynamicFieldConfig(
      id: resolvedId,
      fieldName: fieldName,
      fieldType: resolvedType,
      sequence: json['sequence'] as int? ?? json['order'] as int?,
      validationType: json['validationType'] as int?,
      isMandatory: json['isMandatory'] == true || json['required'] == true,
      stringValueList: json['stringValueList'] as String?,
      value: json['value'] as List<dynamic>?,
      options: resolvedOptions,
      requiredFieldMessage: json['requiredFieldMessage'] as String?,
      placeholder: json['placeholder'] as String?,
      dataKey: json['dataKey']?.toString(),
      description: json['description']?.toString(),
      style: json['style'] is Map<String, dynamic>
          ? json['style'] as Map<String, dynamic>
          : null,
      rawConfig: json,
      minDate: json['minDate'] != null
          ? DateTime.tryParse(json['minDate'].toString())
          : null,
      maxDate: json['maxDate'] != null
          ? DateTime.tryParse(json['maxDate'].toString())
          : null,
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
      isSriLankanPhone:
          json['isSriLankanPhone'] ??
          (resolvedType == DynamicFieldType.phoneNumber.id),
      isSriLankanVehicle: json['isSriLankanVehicle'] ?? false,
      minAttachments: json['minAttachments'] as int?,
      maxAttachments: json['maxAttachments'] as int?,
      matchFieldName: json['matchFieldName'] as String?,
      conditionalShowFieldName: json['conditionalShowFieldName'] as String?,
      conditionalShowFieldValue: json['conditionalShowFieldValue'],
    );
  }

  /// Parses a complete widget envelope or fields list into a list of [DynamicFieldConfig] items.
  static List<DynamicFieldConfig> fromWidgetJson(
    Map<String, dynamic> widgetJson,
  ) {
    List<dynamic>? fields;
    if (widgetJson['fields'] is List) {
      fields = widgetJson['fields'] as List;
    } else if (widgetJson['json'] is Map &&
        (widgetJson['json'] as Map)['fields'] is List) {
      fields = (widgetJson['json'] as Map)['fields'] as List;
    }

    if (fields == null || fields.isEmpty) return [];
    return fromFieldList(fields);
  }

  /// Converts and expands arbitrary backend field definitions into a flat, validated list of [DynamicFieldConfig].
  static List<DynamicFieldConfig> fromFieldList(List<dynamic> fieldList) {
    final List<DynamicFieldConfig> result = [];
    int syntheticIndex = 1;

    for (var raw in fieldList) {
      if (raw is! Map<String, dynamic>) continue;
      final typeStr = (raw['type'] ?? '').toString().toLowerCase();

      // Check for structured table field with row data keys & column pairs
      if (typeStr == 'table' && raw['tableConfig'] is Map<String, dynamic>) {
        final tableConfig = raw['tableConfig'] as Map<String, dynamic>;
        final rows = tableConfig['rows'] as List<dynamic>?;
        final rowDataKeys = tableConfig['rowDataKeys'] as List<dynamic>?;
        final columnPairs = tableConfig['columnPairs'] as List<dynamic>?;
        final cellOptions = tableConfig['cellOptions'] as Map<String, dynamic>?;
        final cellDate = tableConfig['cellDate'] as Map<String, dynamic>?;
        final cellValidation =
            tableConfig['cellValidation'] as Map<String, dynamic>?;

        if (rows != null &&
            rows.isNotEmpty &&
            columnPairs != null &&
            columnPairs.isNotEmpty) {
          final tableLabel = stripHtml(raw['label']?.toString());
          if (tableLabel.isNotEmpty && tableLabel.toLowerCase() != 'table') {
            result.add(
              DynamicFieldConfig(
                id: 'sec_${raw['id'] ?? syntheticIndex++}',
                fieldName: tableLabel,
                fieldType: DynamicFieldType.sectionSplitter.id,
                sequence: (raw['order'] as int? ?? syntheticIndex++) * 100,
              ),
            );
          }

          for (int r = 0; r < rows.length; r++) {
            final rowMap = rows[r] is Map<String, dynamic>
                ? rows[r] as Map<String, dynamic>
                : null;
            if (rowMap == null) continue;

            final keyMap =
                (rowDataKeys != null &&
                    r < rowDataKeys.length &&
                    rowDataKeys[r] is Map<String, dynamic>)
                ? rowDataKeys[r] as Map<String, dynamic>
                : null;

            for (var pair in columnPairs) {
              if (pair is! Map<String, dynamic>) continue;
              final labelColId = pair['labelColumnId']?.toString();
              final valColId = pair['valueColumnId']?.toString();
              if (labelColId == null) continue;

              final rawLabel = rowMap[labelColId]?.toString();
              if (rawLabel == null || rawLabel.trim().isEmpty) continue;
              final label = stripHtml(rawLabel);
              if (label.isEmpty) continue;

              final dataKey = keyMap != null
                  ? keyMap[labelColId]?.toString()
                  : null;
              final cellKey = '$r-$valColId';

              int fType = DynamicFieldType.text.id;
              List<DynamicFieldOption>? options;
              bool isPhone = false;

              if (cellOptions != null &&
                  cellOptions[cellKey] is Map<String, dynamic>) {
                final optList =
                    cellOptions[cellKey]['options'] as List<dynamic>?;
                if (optList != null && optList.isNotEmpty) {
                  fType = DynamicFieldType.dropdown.id;
                  options = optList
                      .map(
                        (o) => DynamicFieldOption(
                          label: o.toString(),
                          value: o.toString(),
                        ),
                      )
                      .toList();
                }
              }

              if (fType == DynamicFieldType.text.id) {
                if (cellDate != null && cellDate[cellKey] != null) {
                  fType = DynamicFieldType.dateTime.id;
                } else if (cellValidation != null &&
                    cellValidation[cellKey] is Map<String, dynamic>) {
                  final kind = cellValidation[cellKey]['kind']?.toString();
                  if (kind == 'number') {
                    fType = DynamicFieldType.number.id;
                  } else if (kind == 'phone') {
                    fType = DynamicFieldType.phoneNumber.id;
                    isPhone = true;
                  }
                }
              }

              result.add(
                DynamicFieldConfig(
                  id: dataKey ?? '${raw['id']}_${r}_$valColId',
                  fieldName: label,
                  fieldType: fType,
                  dataKey: dataKey,
                  sequence:
                      (raw['order'] as int? ?? syntheticIndex++) * 100 + r * 10,
                  options: options,
                  isSriLankanPhone: isPhone,
                  isMandatory: false,
                ),
              );
            }
          }
          continue;
        }
      }

      // Check for customerDetails composite field
      if (typeStr == 'customerdetails') {
        final custConfig = raw['customerConfig'] as Map<String, dynamic>?;
        final reqParts =
            custConfig?['requiredParts'] as List<dynamic>? ?? ['name', 'phone'];
        final baseOrder = (raw['order'] as int? ?? syntheticIndex++) * 100;

        result.add(
          DynamicFieldConfig(
            id: 'sec_customer_${raw['id'] ?? syntheticIndex++}',
            fieldName: stripHtml(
              raw['label']?.toString() ?? 'Lead Customer Details',
            ),
            fieldType: DynamicFieldType.sectionSplitter.id,
            sequence: baseOrder,
          ),
        );

        result.add(
          DynamicFieldConfig(
            id: 'customer_name',
            fieldName: 'Customer Name',
            fieldType: DynamicFieldType.text.id,
            dataKey: 'customer_name',
            isMandatory: reqParts.contains('name'),
            sequence: baseOrder + 1,
          ),
        );

        if (reqParts.contains('phone')) {
          result.add(
            DynamicFieldConfig(
              id: 'customer_phone',
              fieldName: 'Customer Phone',
              fieldType: DynamicFieldType.phoneNumber.id,
              dataKey: 'customer_phone',
              isMandatory: true,
              isSriLankanPhone: true,
              sequence: baseOrder + 2,
            ),
          );
        }

        if (reqParts.contains('email')) {
          result.add(
            DynamicFieldConfig(
              id: 'customer_email',
              fieldName: 'Customer Email',
              fieldType: DynamicFieldType.email.id,
              dataKey: 'customer_email',
              isMandatory: false,
              sequence: baseOrder + 3,
            ),
          );
        }
        continue;
      }

      // Check for userDetails composite field
      if (typeStr == 'userdetails') {
        final userConfig = raw['userDetailsConfig'] as Map<String, dynamic>?;
        final subFields = userConfig?['fields'] as List<dynamic>?;
        final baseOrder = (raw['order'] as int? ?? syntheticIndex++) * 100;

        result.add(
          DynamicFieldConfig(
            id: 'sec_user_${raw['id'] ?? syntheticIndex++}',
            fieldName: stripHtml(
              raw['label']?.toString() ?? 'Collector Details',
            ),
            fieldType: DynamicFieldType.sectionSplitter.id,
            sequence: baseOrder,
          ),
        );

        if (subFields != null && subFields.isNotEmpty) {
          int offset = 1;
          for (var sf in subFields) {
            if (sf is! Map<String, dynamic>) continue;
            final key = sf['key']?.toString() ?? 'user_field_$offset';
            final label = sf['label']?.toString() ?? key;
            int sfType = DynamicFieldType.text.id;
            if (key == 'phone') sfType = DynamicFieldType.phoneNumber.id;
            if (key == 'email') sfType = DynamicFieldType.email.id;

            result.add(
              DynamicFieldConfig(
                id: 'user_$key',
                fieldName: label,
                fieldType: sfType,
                dataKey: 'user_$key',
                sequence: baseOrder + offset++,
              ),
            );
          }
        }
        continue;
      }

      // Default single field parsing
      result.add(DynamicFieldConfig.fromJson(raw));
    }

    return result;
  }

  static Future<List<DynamicFieldConfig>> loadFromAssets(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return fromFieldList(jsonList);
  }
}
