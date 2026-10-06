import 'package:flutter/material.dart';
import 'models/dynamic_field_config.dart';
import 'models/dynamic_field_type.dart';
import 'custom/section_title.dart';
import 'dyno_form_theme.dart';
import 'fields/view/dynamic_view_fields.dart';

class DynamicFormViewWidget extends StatelessWidget {
  final List<DynamicFieldConfig> fields;
  final Map<String, dynamic> formData;
  final DynoFormStyle? style;

  const DynamicFormViewWidget({
    super.key,
    required this.fields,
    required this.formData,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return DynoFormTheme(
      style: style ?? const DynoFormStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: fields.map((field) {
          final type = DynamicFieldType.tryFromId(field.fieldType);
          final value = formData[field.id.toString()];

          if (type == DynamicFieldType.pageBreak) {
            return const SizedBox(height: 16);
          }
          if (type == DynamicFieldType.sectionSplitter) {
            return SectionTitle(field.fieldName);
          }

          Widget fieldWidget;

          switch (type) {
            case DynamicFieldType.attachment:
              fieldWidget = DynamicAttachmentViewField(field: field, value: value);
              break;
            case DynamicFieldType.checkbox:
              fieldWidget = DynamicCheckboxViewField(field: field, value: value);
              break;
            default:
              fieldWidget = DynamicTextViewField(field: field, value: value);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: fieldWidget,
          );
        }).toList(),
      ),
    );
  }
}
