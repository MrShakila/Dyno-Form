part of 'dynamic_fields.dart';

class DynamicRadioField extends StatefulWidget {
  final DynamicFieldConfig field;

  const DynamicRadioField({super.key, required this.field});

  @override
  State<DynamicRadioField> createState() => _DynamicRadioFieldState();
}

class _DynamicRadioFieldState extends State<DynamicRadioField> {
  @override
  Widget build(BuildContext context) {
    final String controlName = widget.field.id.toString();
    return ReactiveValueListenableBuilder(
      formControlName: controlName,
      builder: (context, control, child) {
        final Color? dynamicFillColor = getDynamicFillColor(control, context);
        return ReactiveFormField(
          formControlName: controlName,
          builder: (ReactiveFormFieldState<String, String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text.rich(
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.field.fieldName,
                          // Add your default style here if needed, e.g., style: TextStyle(color: Colors.black)
                        ),
                        if (widget.field.isMandatory)
                           TextSpan(
                            text: " *",
                            style: TextStyle(color: DynoFormTheme.of(context).mandatoryStarColor ?? Theme.of(context).colorScheme.error),
                          ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: (widget.field.options ?? []).length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) =>
                      ReactiveRadioListTile<String>(
                        tileColor: dynamicFillColor,
                        formControlName: widget.field.id.toString(),
                        value: widget.field.options![index].value,
                        dense: Theme.of(context).inputDecorationTheme.isDense,
                        title: Text(widget.field.options![index].label),
                      ),
                ),
                if (field.control.touched && field.control.invalid) ...[
                  const SizedBox(height: 8),
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
          },
        );
      },
    );
  }
}
