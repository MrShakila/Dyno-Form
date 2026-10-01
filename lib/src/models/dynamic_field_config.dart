class DynamicFieldOption {
  final String label;
  final dynamic value;
  const DynamicFieldOption({required this.label, required this.value});
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
}
