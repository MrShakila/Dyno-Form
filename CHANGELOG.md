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
