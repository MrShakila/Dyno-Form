## 1.3.0

### Major Features & Architectural Overhaul
* **Stepper UI & Pagination**: Set `enableStepper: true` to automatically divide forms into a multi-page wizard using `pageBreak` fields. Includes Next/Previous navigation and dynamic progress indicators.
* **Dynamic Submit Button**: "Submit" is now smartly disabled until all fields on the final step are valid.
* **Save as Draft Bypass**: Add a "Save as Draft" button (`showDraftButton: true`) to bypass strict validations and save partial progress.
* **Conditional Visibility Engine**: Forms now actively listen to `conditionalShowFieldName` streams and dynamically mount/unmount child widgets while safely enabling/disabling their validators.
* **Cross-Field Validations**: Pass a `matchFieldName` (e.g. Confirm Password must match Password) to enforce cross-field identical value matching.

### Advanced Validations Added
* Added `sequence` to `DynamicFieldConfig` for automatic pre-rendering sorting.
* Added `minLength` and `maxLength` (for both text and list fields).
* Added explicit `minAttachments` and `maxAttachments` for strict media upload limitations.
* Added support for `regexPattern` custom validation.
* **Sri Lankan Localization**: Added strict built-in regex validators for Sri Lankan NIC (`isSriLankanNIC`), Phone (`isSriLankanPhone`), and Vehicle Plates (`isSriLankanVehicle`).

## 1.2.0

* Introduced `DynamicFormViewWidget` for rendering read-only dynamic forms based on field type and submitted data.
* Extracted individual view widgets (`DynamicTextViewField`, `DynamicCheckboxViewField`, `DynamicAttachmentViewField`) for modularity and maintainability.
* Improved attachment field parsing (handles local paths, network URLs, and `SelectedFile` types seamlessly with built-in interactive preview dialogs).
* Updated `README.md` to reference `dyno_form` correctly.

## 1.0.3

* Added `example` app so pub.dev correctly displays the Example tab.
* Implemented start date and end date cross-field boundaries.
* Added extensive theming support via `DynoFormStyle` and `DynoFormTheme` to override hardcoded colors.

## 1.0.0

* Initial release of dyno_form!
* Features a fully dynamic, JSON-driven form builder built on top of reactive_forms.
* Included field types: Text, TextArea, Email, Password, Phone Number, Dropdown, Radio, Checkbox, CheckText, Attachments, DateTime, and layout splitters.
* Cleaned up lints and ready for production use.
