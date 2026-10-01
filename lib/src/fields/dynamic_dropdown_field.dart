part of 'dynamic_fields.dart';

class DynamicDropdownField extends StatefulWidget {
  final DynamicFieldConfig field;

  const DynamicDropdownField({super.key, required this.field});

  @override
  State<DynamicDropdownField> createState() => _DynamicDropdownFieldState();
}

class _DynamicDropdownFieldState extends State<DynamicDropdownField> {
  @override
  Widget build(BuildContext context) {
    try {
      final String controlName = widget.field.id.toString();

      return ReactiveValueListenableBuilder(
        formControlName: controlName,
        builder: (context, control, child) {
          final Color? dynamicFillColor = getDynamicFillColor(control, context);
          return ReactiveDropdownField<String>(
            formControlName: controlName,
            decoration: InputDecoration(
              fillColor: dynamicFillColor,
              hintStyle: const TextStyle(color: Colors.grey),
              label: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: widget.field.fieldName),
                    if (widget.field.isMandatory)
                       TextSpan(
                        text: " *",
                        style: TextStyle(color: DynoFormTheme.of(context).mandatoryStarColor ?? Theme.of(context).colorScheme.error),
                      ),
                  ],
                ),
              ),
            ),
            items: (widget.field.options ?? []).map((e) {
              return DropdownMenuItem<String>(
                value: e.value,
                child: Text(e.label),
              );
            }).toList(),
            validationMessages: {
              ValidationMessage.required: (_) => ValidationMessages.requiredField,
            },
          );
        },
      );
    } on Exception catch (e) {
      return Text('Error rendering field: $e');
    }
  }
}
