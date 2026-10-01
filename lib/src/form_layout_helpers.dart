import 'models/dynamic_field_type.dart';
import 'models/dynamic_field_config.dart';

int formColumnCount(double availableWidth) {
  if (availableWidth >= 1200) return 3;
  if (availableWidth >= 600) return 2;
  return 1;
}

bool isWideFormField(DynamicFieldType? type) {
  return type == DynamicFieldType.textArea ||
      type == DynamicFieldType.attachment ||
      type == DynamicFieldType.checkText ||
      type == DynamicFieldType.radio;
}

class FormSection {
  final String title;
  final List<DynamicFieldConfig> fields;

  FormSection({required this.title, required this.fields});
}

List<FormSection> groupFieldsIntoSections(
  List<DynamicFieldConfig> fields,
) {
  final List<FormSection> sections = [];
  List<DynamicFieldConfig> currentFields = [];
  String currentSectionTitle = 'Details';

  for (final field in fields) {
    final fieldType = DynamicFieldType.tryFromId(field.fieldType);
    if (fieldType == DynamicFieldType.sectionSplitter) {
      if (currentFields.isNotEmpty) {
        sections.add(
          FormSection(title: currentSectionTitle, fields: currentFields),
        );
      }
      currentFields = [];
      currentSectionTitle = field.fieldName;
    } else {
      currentFields.add(field);
    }
  }

  if (currentFields.isNotEmpty) {
    sections.add(
      FormSection(title: currentSectionTitle, fields: currentFields),
    );
  }

  return sections;
}
