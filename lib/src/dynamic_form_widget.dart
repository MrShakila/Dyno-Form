import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';

import 'models/dynamic_field_config.dart';
import 'models/dynamic_field_type.dart';
import 'fields/dynamic_fields.dart';
import 'custom/section_title.dart';
import 'custom/dynamic_custom_checktext_field.dart';
import 'dyno_form_theme.dart';

class DynamicFormWidget extends StatefulWidget {
  final List<DynamicFieldConfig> fields;
  final void Function(Map<String, dynamic>)? onSubmit;
  final String submitButtonText;
  final DynoFormStyle? style;
  
  const DynamicFormWidget({
    super.key,
    required this.fields,
    this.onSubmit,
    this.submitButtonText = 'Submit',
    this.style,
  });

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup(_generateFormFields());
  }

  Map<String, FormControl> _generateFormFields() {
    final Map<String, FormControl> controls = {};
    for (final field in widget.fields) {
      final type = DynamicFieldType.tryFromId(field.fieldType);
      if (type?.isInputElement == true) {
        if (type == DynamicFieldType.checkbox) {
          controls[field.id.toString()] = FormControl<bool>(
            validators: field.isMandatory ? [Validators.requiredTrue] : [],
          );
        } else if (type == DynamicFieldType.dateTime) {
          controls[field.id.toString()] = FormControl<DateTime>(
            validators: field.isMandatory ? [Validators.required] : [],
          );
        } else if (type == DynamicFieldType.text || 
                   type == DynamicFieldType.textArea || 
                   type == DynamicFieldType.email || 
                   type == DynamicFieldType.password || 
                   type == DynamicFieldType.phoneNumber ||
                   type == DynamicFieldType.vehicleNumber ||
                   type == DynamicFieldType.number ||
                   type == DynamicFieldType.dropdown ||
                   type == DynamicFieldType.radio ||
                   type == DynamicFieldType.checkText) {
          final List<Validator<dynamic>> fieldValidators = [];
          if (field.isMandatory) fieldValidators.add(Validators.required);
          if (type == DynamicFieldType.email) fieldValidators.add(Validators.email);
          if (type == DynamicFieldType.phoneNumber) fieldValidators.add(Validators.pattern(RegExp(r'^\+?[0-9\s]+$')));
          
          controls[field.id.toString()] = FormControl<String>(
            validators: fieldValidators,
          );
        } else if (type == DynamicFieldType.attachment) {
          controls[field.id.toString()] = FormControl<List<SelectedFile>>(
            validators: field.isMandatory ? [Validators.required] : [],
            value: [],
          );
        } else {
          controls[field.id.toString()] = FormControl<dynamic>(
            validators: field.isMandatory ? [Validators.required] : [],
          );
        }
      }
    }
    return controls;
  }

  @override
  Widget build(BuildContext context) {
    return DynoFormTheme(
      style: widget.style ?? const DynoFormStyle(),
      child: Builder(
        builder: (context) {
          return ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...widget.fields.map((field) {
                  final type = DynamicFieldType.tryFromId(field.fieldType);
                  
                  if (type == DynamicFieldType.pageBreak) {
                    return const SizedBox(height: 16);
                  }
                  if (type == DynamicFieldType.sectionSplitter) {
                    return SectionTitle(field.fieldName);
                  }

                  Widget fieldWidget;
                  switch (type) {
                    case DynamicFieldType.dropdown:
                      fieldWidget = DynamicDropdownField(field: field);
                      break;
                    case DynamicFieldType.radio:
                      fieldWidget = DynamicRadioField(field: field);
                      break;
                    case DynamicFieldType.checkbox:
                      fieldWidget = DynamicCheckboxField(field: field);
                      break;
                    case DynamicFieldType.checkText:
                      fieldWidget = DynamicCustomCheckTextField(
                        formControlName: field.id.toString(),
                        decoration: InputDecoration(
                          labelText: field.fieldName,
                        ),
                      );
                      break;
                    case DynamicFieldType.attachment:
                      fieldWidget = DynamicAttachmentField(field: field);
                      break;
                    case DynamicFieldType.dateTime:
                      fieldWidget = DynamicDateTimeField(field: field);
                      break;
                    default:
                      fieldWidget = DynamicTextField(
                        field: field,
                        textEditingValue: const TextEditingValue(),
                      );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: fieldWidget,
                  );
                }),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: DynoFormTheme.of(context).submitButtonStyle,
                  onPressed: () {
                    if (form.valid) {
                      widget.onSubmit?.call(form.value);
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  child: Text(widget.submitButtonText),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
