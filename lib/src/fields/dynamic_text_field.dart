part of 'dynamic_fields.dart';

class DynamicTextField extends StatefulWidget {
  final DynamicFieldConfig field;
  final TextEditingValue? textEditingValue;
  const DynamicTextField({
    super.key,
    required this.field,
    required this.textEditingValue,
  });

  @override
  State<DynamicTextField> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  @override
  Widget build(BuildContext context) {
    final type = DynamicFieldType.tryFromId(widget.field.fieldType);
    final String controlName = widget.field.id.toString();
    return ReactiveValueListenableBuilder<String>(
      formControlName: controlName,
      builder: (context, control, child) {
        final Color? dynamicFillColor = getDynamicFillColor(control);
        return ReactiveTextField(
          formControlName: controlName,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: type == DynamicFieldType.phoneNumber
              ? InputDecoration(
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixText: '+94 ',

                  hintText: '7XXXXXXX',
                  fillColor: dynamicFillColor, // Use dynamic fill
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: widget.field.fieldName),
                          if (widget.field.isMandatory)
                            const TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              : InputDecoration(
                  fillColor: dynamicFillColor, // Use dynamic fill
                  hintStyle: const TextStyle(color: Colors.grey),
                  label: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: widget.field.fieldName),
                        if (widget.field.isMandatory)
                          const TextSpan(
                            text: " *",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),

          obscureText: obscureText,
          textCapitalization: textCapitalization,
          keyboardType: inputType,
          maxLines: maxLines,
          textInputAction: TextInputAction.next,
          textAlign: textAlign,
          validationMessages: _buildValidationMessages(widget.field),
        );
      },
    );
  }

  Map<String, String Function(Object)> _buildValidationMessages(
    DynamicFieldConfig field,
  ) {
    final messages = <String, String Function(Object)>{};

    if (field.isMandatory) {
      messages[ValidationMessage.required] = (_) =>
          ValidationMessages.requiredField;
    }

    final DynamicFieldType? fieldType = DynamicFieldType.tryFromId(
      field.fieldType,
    );
    switch (fieldType) {
      case DynamicFieldType.email:
        messages[DynamicFieldValidationType.email.name] = (_) =>
            ValidationMessages.invalidEmail;
        break;
      case DynamicFieldType.phoneNumber:
        messages[DynamicFieldValidationType.phoneNumber.name] = (_) =>
            ValidationMessages.invalidPhoneNumber;
        break;
      case DynamicFieldType.vehicleNumber:
        messages[DynamicFieldValidationType.vehicleNumber.name] = (_) =>
            ValidationMessages.invalidVehicleNumber;
        break;
      default:
        break;
    }

    return messages;
  }

  bool get obscureText =>
      DynamicFieldType.tryFromId(widget.field.fieldType) ==
      DynamicFieldType.password;

  TextCapitalization get textCapitalization {
    return DynamicFieldType.tryFromId(widget.field.fieldType) ==
            DynamicFieldType.password
        ? TextCapitalization.none
        : TextCapitalization.sentences;
  }

  int get maxLines {
    return DynamicFieldType.tryFromId(widget.field.fieldType) ==
            DynamicFieldType.textArea
        ? 5
        : 1;
  }

  TextAlign get textAlign => maxLines > 1 ? TextAlign.start : TextAlign.start;

  TextInputType? get inputType {
    switch (DynamicFieldType.tryFromId(widget.field.fieldType)) {
      case DynamicFieldType.number:
        return TextInputType.number;
      case DynamicFieldType.textArea:
        return TextInputType.multiline;
      case DynamicFieldType.phoneNumber:
        return TextInputType.phone;
      case DynamicFieldType.email:
        return TextInputType.emailAddress;
      case DynamicFieldType.text:
      case DynamicFieldType.password:
      default:
        return TextInputType.text;
    }
  }
}

/// Calculates the background color based on control state
Color? getDynamicFillColor(AbstractControl control) {
  // 1. If empty, keep standard color (null/white/theme default)
  if (control.value == null || control.value.toString().isEmpty) {
    return null;
  }

  // 2. If it has errors, show Red tint
  if (control.hasErrors && control.touched) {
    return Colors.redAccent.withOpacity(0.1);
  }

  // 3. If filled and valid, show Green tint
  return Colors.greenAccent.withOpacity(
    0.5,
  ); // Reduced opacity for better readability
}

Color? getCheckboxColor(AbstractControl<dynamic> control) {
  final value = control.value;
  // ReactiveForms booleans can be null, true, or false.
  // Treat null as false.
  final bool isChecked = value == true;

  // 1. Error State: Required but unchecked (and touched)
  if (control.hasErrors && control.touched) {
    return Colors.redAccent.withOpacity(0.1);
  }

  // 2. Success State: Checked
  if (isChecked) {
    return Colors.greenAccent.withOpacity(0.5);
  }

  // 3. Default State: Unchecked and valid (or untouched)
  return null;
}
