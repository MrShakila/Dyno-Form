import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DynamicCustomCheckTextField<T> extends ReactiveFormField<T, String> {
  DynamicCustomCheckTextField({
    super.key,
    super.formControlName,
    super.formControl,
    InputDecoration? decoration,
    super.validationMessages,
    TextStyle? style,
    super.showErrors,
    WidgetStateProperty<Color?>? fillColor,
    Color? checkColor,
    EdgeInsetsGeometry? contentPadding,
    ShapeBorder? shape,
    OutlinedBorder? checkboxShape,
    ValueChanged<T?>? onChanged,
  }) : super(
         builder: (field) {
           return StreamBuilder<Object>(
             stream: null,
             builder: (context, snapshot) {
               return ReactiveTextField(
                 formControlName: formControlName,
                 formControl: formControl,
                 decoration:
                     (decoration ??
                             const InputDecoration(
                               hintStyle: TextStyle(color: Colors.grey),
                             ))
                         .copyWith(
                           prefixIcon: Padding(
                             padding: const EdgeInsets.only(
                               left: 8.0,
                               right: 8.0,
                             ),
                             child: Checkbox(
                               value:
                                   (field.value != null &&
                                   field.value != "false"),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(4),
                               ),
                               fillColor:
                                   (field.value != null &&
                                       field.value != "false")
                                   ? (fillColor ??
                                         WidgetStateProperty.all(
                                           Theme.of(context)
                                               .colorScheme
                                               .primary,
                                         ))
                                   : null,
                               checkColor: checkColor,
                               isError: field.errorText != null,
                               onChanged: field.control.enabled
                                   ? (value) {
                                       if (value ?? false) {
                                         field.didChange(
                                           field.value?.isEmpty ?? true
                                               ? ' '
                                               : field.value,
                                         );
                                       } else {
                                         field.didChange(null);
                                       }
                                     }
                                   : null,
                             ),
                           ),
                         ),
                 keyboardType: TextInputType.name,
                 textInputAction: TextInputAction.next,
               );
             },
           );
         },
       );
}
