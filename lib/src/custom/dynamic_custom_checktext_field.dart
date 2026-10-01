
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
                           prefixIcon: Transform.scale(
                             scale: 1.2,
                             child: Container(
                               margin: const EdgeInsets.only(
                                 right: 16,
                                 left: 6,
                               ),
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(100),
                                 border: Border.all(
                                   color: Theme.of(context).colorScheme.primary,
                                   width: 2,
                                 ),
                                 // color: Colors.purple,
                               ),
                               child: Transform.scale(
                                 scale: 2,
                                 child: Checkbox(
                                   value:
                                       (field.value != null &&
                                       field.value != "false"),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   fillColor:
                                       (field.value != null &&
                                           field.value != "false")
                                       ? (fillColor ??
                                             WidgetStateProperty.all(
                                               Theme.of(context).colorScheme.primary,
                                             ))
                                       : WidgetStateProperty.all(
                                           Theme.of(
                                             context,
                                           ).colorScheme.surface,
                                         ),
                                   checkColor: checkColor,
                                   isError: field.errorText != null,
                                   onChanged: field.control.enabled
                                       ? (value) {
                                           if (value ?? false) {
                                             field.didChange('');
                                           } else {
                                             field.didChange(null);
                                           }
                                         }
                                       : null,
                                 ),
                               ),
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
