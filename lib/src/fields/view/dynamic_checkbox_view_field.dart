import 'package:flutter/material.dart';
import '../../models/dynamic_field_config.dart';

class DynamicCheckboxViewField extends StatelessWidget {
  final DynamicFieldConfig field;
  final dynamic value;

  const DynamicCheckboxViewField({
    super.key,
    required this.field,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = (value == true) ? 'Yes' : 'No';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.fieldName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(displayValue, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}
