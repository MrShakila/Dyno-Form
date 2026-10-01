part of 'dynamic_fields.dart';

class DynamicCheckboxField extends StatefulWidget {
  final DynamicFieldConfig field;

  const DynamicCheckboxField({super.key, required this.field});

  @override
  State<DynamicCheckboxField> createState() => _DynamicCheckboxFieldState();
}

class _DynamicCheckboxFieldState extends State<DynamicCheckboxField> {
  @override
  Widget build(BuildContext context) {
    final String controlName = widget.field.id.toString();
    return ReactiveValueListenableBuilder(
      formControlName: controlName,
      builder: (context, control, child) {
        final Color? dynamicFillColor = getCheckboxColor(control);
        return ReactiveFormField(
          formControlName: controlName,
          builder: (ReactiveFormFieldState<bool, bool> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ReactiveCheckboxListTile(
                  tileColor: dynamicFillColor,
                  formControlName: widget.field.id.toString(),
                  title: Text.rich(
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
                  contentPadding: const EdgeInsets.only(left: 12),
                ),
                if (field.control.touched && field.control.invalid) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      field.errorText ?? ValidationMessages.invalidField,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
          validationMessages: {
            ValidationMessage.required: (_) =>
                // widget.field.requiredFieldMessage ??
                ValidationMessages.requiredField,
            ValidationMessage.requiredTrue: (_) =>
                // widget.field.requiredFieldMessage ??
                ValidationMessages.requiredField,
          },
        );
      },
    );
  }
}
