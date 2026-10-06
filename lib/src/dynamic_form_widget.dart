import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';

import 'models/dynamic_field_config.dart';
import 'models/dynamic_field_type.dart';
import 'dynamic_field_validation_type.dart';
import 'fields/dynamic_fields.dart';
import 'custom/section_title.dart';
import 'custom/dynamic_custom_checktext_field.dart';
import 'dyno_form_theme.dart';

class DynamicFormWidget extends StatefulWidget {
  final List<DynamicFieldConfig> fields;
  final void Function(Map<String, dynamic>)? onSubmit;
  final String submitButtonText;
  final DynoFormStyle? style;
  final bool enableStepper;
  final bool showDraftButton;
  final void Function(Map<String, dynamic>)? onDraftSubmit;
  final String draftButtonText;
  
  const DynamicFormWidget({
    super.key,
    required this.fields,
    this.onSubmit,
    this.submitButtonText = 'Submit',
    this.style,
    this.enableStepper = false,
    this.showDraftButton = false,
    this.onDraftSubmit,
    this.draftButtonText = 'Save Draft',
  });

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  late FormGroup form;
  late List<DynamicFieldConfig> _sortedFields;
  int _currentStep = 0;
  List<List<DynamicFieldConfig>> _pages = [];

  @override
  void initState() {
    super.initState();
    
    _sortedFields = List.from(widget.fields);
    _sortedFields.sort((a, b) => (a.sequence ?? 9999).compareTo(b.sequence ?? 9999));
    
    final List<Validator<dynamic>> groupValidators = [];
    for (final field in _sortedFields) {
      if (field.matchFieldName != null && field.matchFieldName!.isNotEmpty) {
        groupValidators.add(Validators.mustMatch(field.matchFieldName!, field.id.toString()));
      }
    }
    
    form = FormGroup(_generateFormFields(), validators: groupValidators);
    
    _pages = [];
    List<DynamicFieldConfig> currentPage = [];
    for (final field in _sortedFields) {
      if (DynamicFieldType.tryFromId(field.fieldType) == DynamicFieldType.pageBreak) {
        if (currentPage.isNotEmpty) {
          _pages.add(currentPage);
          currentPage = [];
        }
      } else {
        currentPage.add(field);
      }
    }
    if (currentPage.isNotEmpty) {
      _pages.add(currentPage);
    }
    if (_pages.isEmpty) _pages.add([]);
    
    // Setup Conditional Logic Listeners
    for (final field in _sortedFields) {
      if (field.conditionalShowFieldName != null && field.conditionalShowFieldName!.isNotEmpty) {
        final parentControl = form.control(field.conditionalShowFieldName!);
        final thisControl = form.control(field.id.toString());
        
        // Initial check
        if (parentControl.value?.toString() != field.conditionalShowFieldValue?.toString()) {
          thisControl.markAsDisabled();
        }
        
        // Listen for future changes
        parentControl.valueChanges.listen((value) {
          if (value?.toString() == field.conditionalShowFieldValue?.toString()) {
            thisControl.markAsEnabled();
          } else {
            thisControl.markAsDisabled();
            thisControl.value = null; // Clear value when hidden
          }
        });
      }
    }
  }

  bool _isCurrentPageValid() {
    if (!widget.enableStepper) return form.valid;
    bool isValid = true;
    for (var field in _pages[_currentStep]) {
      final type = DynamicFieldType.tryFromId(field.fieldType);
      if (type?.isInputElement == true) {
        final control = form.control(field.id.toString());
        if (control.invalid) {
          control.markAsTouched();
          isValid = false;
        }
      }
    }
    return isValid;
  }

  Map<String, FormControl> _generateFormFields() {
    final Map<String, FormControl> controls = {};
    for (final field in _sortedFields) {
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
          
          final valType = DynamicFieldValidationType.tryFromType(field.validationType);
          if (valType == DynamicFieldValidationType.email) fieldValidators.add(Validators.email);
          if (valType == DynamicFieldValidationType.phoneNumber || field.isSriLankanPhone) {
            fieldValidators.add(Validators.pattern(RegExp(r'^(?:\+94|0)?(?:7\d|11)\d{7}$')));
          }
          if (valType == DynamicFieldValidationType.vehicleNumber || field.isSriLankanVehicle) {
            fieldValidators.add(Validators.pattern(RegExp(r'^[A-Za-z]{2,3}-\d{4}$')));
          }
          if (valType == DynamicFieldValidationType.nic || field.isSriLankanNIC) {
            fieldValidators.add(Validators.pattern(RegExp(r'^(?:19|20)?\d{2}[0-35-8]\d{2}\d{4}[vVxX]?$')));
          }
          
          if (field.minLength != null) fieldValidators.add(Validators.minLength(field.minLength!));
          if (field.maxLength != null) fieldValidators.add(Validators.maxLength(field.maxLength!));
          if (field.regexPattern != null && field.regexPattern!.isNotEmpty) {
            fieldValidators.add(Validators.pattern(RegExp(field.regexPattern!)));
          }
          
          controls[field.id.toString()] = FormControl<String>(
            validators: fieldValidators,
          );
        } else if (type == DynamicFieldType.attachment) {
          final List<Validator<dynamic>> attachmentValidators = [];
          if (field.isMandatory) attachmentValidators.add(Validators.required);
          if (field.minAttachments != null) attachmentValidators.add(Validators.minLength(field.minAttachments!));
          if (field.maxAttachments != null) attachmentValidators.add(Validators.maxLength(field.maxAttachments!));
          
          controls[field.id.toString()] = FormControl<List<SelectedFile>>(
            validators: attachmentValidators,
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
    final fieldsToRender = widget.enableStepper ? _pages[_currentStep] : _sortedFields;
    
    return DynoFormTheme(
      style: widget.style ?? const DynoFormStyle(),
      child: Builder(
        builder: (context) {
          return ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.enableStepper && _pages.length > 1) ...[
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _pages.length,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text('Step ${_currentStep + 1} of ${_pages.length}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                ],
                ...fieldsToRender.map((field) {
                  final type = DynamicFieldType.tryFromId(field.fieldType);
                  
                  if (type == DynamicFieldType.pageBreak) {
                    return const SizedBox.shrink();
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

                  if (field.conditionalShowFieldName != null && field.conditionalShowFieldName!.isNotEmpty) {
                    return ReactiveValueListenableBuilder<dynamic>(
                      formControlName: field.conditionalShowFieldName!,
                      builder: (context, control, child) {
                        final isVisible = control.value?.toString() == field.conditionalShowFieldValue?.toString();
                        if (!isVisible) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: child!,
                        );
                      },
                      child: fieldWidget,
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: fieldWidget,
                  );
                }),
                const SizedBox(height: 24),
                _buildActionButtons(context),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isLastStep = !widget.enableStepper || _currentStep == _pages.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.enableStepper && _currentStep > 0)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep--;
              });
            },
            child: const Text('Previous'),
          )
        else
          const SizedBox.shrink(),
          
        Row(
          children: [
            if (widget.showDraftButton)
              TextButton(
                onPressed: () {
                  widget.onDraftSubmit?.call(form.value);
                },
                child: Text(widget.draftButtonText),
              ),
            if (widget.showDraftButton) const SizedBox(width: 8),
            
            if (!isLastStep)
              ElevatedButton(
                onPressed: () {
                  if (_isCurrentPageValid()) {
                    setState(() {
                      _currentStep++;
                    });
                  }
                },
                child: const Text('Next'),
              )
            else
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return ElevatedButton(
                    style: DynoFormTheme.of(context).submitButtonStyle,
                    onPressed: form.valid
                        ? () {
                            widget.onSubmit?.call(form.value);
                          }
                        : null,
                    child: Text(widget.submitButtonText),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}
