part of 'dynamic_fields.dart';

class DynamicDateTimeField extends StatefulWidget {
  final DynamicFieldConfig field;

  const DynamicDateTimeField({super.key, required this.field});

  @override
  State<DynamicDateTimeField> createState() => _DynamicDateTimeFieldState();
}

class _DynamicDateTimeFieldState extends State<DynamicDateTimeField> {
  @override
  Widget build(BuildContext context) {
    final String controlName = widget.field.id.toString();
    return ReactiveValueListenableBuilder(
      formControlName: controlName,
      builder: (context, control, child) {
        final Color? dynamicFillColor = getDynamicFillColor(control);
        return ReactiveDateTimePicker(
          formControlName: controlName,
          type: ReactiveDatePickerFieldType.date,

          decoration: InputDecoration(
            fillColor: dynamicFillColor,
            hintStyle: TextStyle(color: Colors.grey),
            label: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.field.fieldName,
                    // Add your default style here if needed, e.g., style: TextStyle(color: Colors.black)
                  ),
                  if (widget.field.isMandatory)
                    const TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            // helperText: widget.field.placeholder,
          ),
          validationMessages: {
            ValidationMessage.required: (_) =>
                // widget.field.requiredFieldMessage ??
                ValidationMessages.requiredField,
          },
        );
      },
    );
  }
}
