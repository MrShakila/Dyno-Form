part of 'dynamic_fields.dart';

class DynamicAttachmentField extends StatefulWidget {
  final DynamicFieldConfig field;
  final int imageQuality;
  final Function(String)? onDeleteImage;
  const DynamicAttachmentField({
    super.key,
    required this.field,
    this.imageQuality = 75,
    this.onDeleteImage,
  });

  @override
  State<DynamicAttachmentField> createState() => _DynamicAttachmentFieldState();
}

class _DynamicAttachmentFieldState extends State<DynamicAttachmentField> {
  @override
  Widget build(BuildContext context) {
    final String controlName = widget.field.id.toString();
    return ReactiveValueListenableBuilder(
      formControlName: controlName,
      builder: (context, control, child) {
        final Color? dynamicFillColor = getImagePickerColor(control, context);
        return ReactiveImagePicker(
          formControlName: controlName,
          decoration: InputDecoration(
            fillColor: dynamicFillColor,

            hintStyle: const TextStyle(color: Colors.grey),
            label: Text.rich(
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
          validationMessages: {
            ValidationMessage.required: (_) => ValidationMessages.requiredField,
          },
        );
      },
    );
  }
}

Color? getImagePickerColor(AbstractControl<dynamic> control, BuildContext context) {
  final style = DynoFormTheme.of(context);
  // 1. Get value safely
  final value = control.value;

  // 2. Check if list is populated
  // We check 'is List' to be safe, then check emptiness
  final bool hasImages = value is List && value.isNotEmpty;

  // 3. Error State: Empty + Touched + Required (Error)
  if (control.hasErrors && control.touched) {
    return style.errorFillColor ?? Theme.of(context).colorScheme.error.withValues(alpha: 0.1);
  }

  // 4. Success State: Has images
  if (hasImages) {
    return style.successFillColor ?? Colors.greenAccent.withValues(alpha: 0.5);
  }

  // 5. Default State
  return null; // Or Colors.grey[100] for a placeholder look
}
