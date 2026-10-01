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
    return ReactiveFormConsumer(
      builder: (context, formGroup, child) {
        DateTime firstDate = widget.field.minDate ?? DateTime(1900);
        DateTime lastDate = widget.field.maxDate ?? DateTime(2100);

        if (widget.field.minDateFromField != null && formGroup.contains(widget.field.minDateFromField!)) {
          final minVal = formGroup.control(widget.field.minDateFromField!).value;
          if (minVal is DateTime) {
            firstDate = minVal;
          }
        }

        if (widget.field.maxDateFromField != null && formGroup.contains(widget.field.maxDateFromField!)) {
          final maxVal = formGroup.control(widget.field.maxDateFromField!).value;
          if (maxVal is DateTime) {
            lastDate = maxVal;
          }
        }

        // Prevent crashes if bounds cross (e.g. user selects invalid combinations across fields)
        if (firstDate.isAfter(lastDate)) {
          lastDate = firstDate;
        }

        final control = formGroup.control(controlName);
        final Color? dynamicFillColor = getDynamicFillColor(control);
        
        return ReactiveDateTimePicker(
          formControlName: controlName,
          type: ReactiveDatePickerFieldType.date,
          firstDate: firstDate,
          lastDate: lastDate,
          decoration: InputDecoration(
            fillColor: dynamicFillColor,
            hintStyle: const TextStyle(color: Colors.grey),
            label: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.field.fieldName,
                  ),
                  if (widget.field.isMandatory)
                    const TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
          validationMessages: {
            ValidationMessage.required: (_) => ValidationMessages.requiredField,
          },
        );
      },
    );
  }
}
