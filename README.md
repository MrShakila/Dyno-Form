# Form Craft 🛠️

A dynamic, JSON-driven, and highly reactive form builder for Flutter. Powered by `reactive_forms`, **Form Craft** allows you to seamlessly generate complex, validated, and interactive forms from a simple list of configurations or a JSON payload.

## Features ✨

- **Fully Dynamic & Data-Driven:** Build your entire UI layout from a simple JSON array or a list of `DynamicFieldConfig` models.
- **Robust Validation:** Integrated tightly with `reactive_forms`. Automatically handles required fields, email formatting, phone numbers, custom regex patterns, and more.
- **Rich Input Types:** Built-in support for:
  - Text, Text Area, Email, Passwords, Phone Numbers, Numbers, and Vehicle Numbers
  - Dropdowns & Radio Buttons
  - Checkboxes & Custom Checkbox-Text combinations
  - Date & Time pickers
  - File/Image Attachments
  - UI Elements: Page Breaks and Section Splitters
- **Error Handling & UI States:** Beautifully animated UI feedback out-of-the-box (e.g. green tint for valid fields, red tint for errors).
- **Material 3 Ready:** Fits perfectly into modern Flutter applications.

## Getting started 🚀

### 1. Depend on it
If it's published to pub.dev, add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  form_craft: ^0.0.1
```

*(Alternatively, you can pull it directly from git if needed)*:
```yaml
dependencies:
  form_craft:
    git:
      url: https://github.com/MrShakila/Form-Craft.git
      ref: main
```

### 2. Install it
Run this command in your terminal:
```bash
flutter pub get
```

## Usage 💡

### Quick Implementation

Simply import the package and use the `DynamicFormWidget`. You can provide your fields directly in Dart or load them asynchronously from a JSON asset.

```dart
import 'package:flutter/material.dart';
import 'package:form_craft/form_craft.dart';

class MyFormScreen extends StatelessWidget {
  const MyFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DynamicFormWidget(
          submitButtonText: 'Submit Form',
          fields: [
            DynamicFieldConfig(
              id: 1,
              fieldName: 'Full Name',
              fieldType: DynamicFieldType.text.id,
              isMandatory: true,
              placeholder: 'Enter your full name',
            ),
            DynamicFieldConfig(
              id: 2,
              fieldName: 'Gender',
              fieldType: DynamicFieldType.dropdown.id,
              isMandatory: true,
              options: const [
                DynamicFieldOption(label: 'Male', value: 'Male'),
                DynamicFieldOption(label: 'Female', value: 'Female'),
              ],
            ),
            DynamicFieldConfig(
              id: 3,
              fieldName: 'I agree to the terms',
              fieldType: DynamicFieldType.checkbox.id,
              isMandatory: true,
            ),
          ],
          onSubmit: (Map<String, dynamic> formData) {
            print('Form submitted successfully!');
            print(formData);
          },
        ),
      ),
    );
  }
}
```

### Loading from JSON (Backend or Assets)

If your form configurations are driven by a backend or stored locally in your assets, `form_craft` makes it easy to parse them:

```dart
// Fetch the config asynchronously from an asset
final List<DynamicFieldConfig> fields = await DynamicFieldConfig.loadFromAssets('assets/form_config.json');

// Or parse from a backend API response
final List<dynamic> jsonList = jsonDecode(apiResponse.body);
final List<DynamicFieldConfig> fields = jsonList.map((e) => DynamicFieldConfig.fromJson(e)).toList();
```

## Supported Field Types 📋

The `DynamicFieldType` enum maps integers to specific form inputs. Here are the core types available:

| ID | Type | Description |
|---|---|---|
| 1 | `text` | Standard text input field. |
| 2 | `dateTime` | Date and time picker. |
| 3 | `checkbox` | Standard boolean checkbox. |
| 5 | `number` | Numeric keyboard input. |
| 6 | `dropdown` | Dropdown menu (requires `options`). |
| 7 | `phoneNumber` | Phone number formatting and validation. |
| 8 | `textArea` | Multi-line text input. |
| 9 | `radio` | Radio button group (requires `options`). |
| 10 | `checkText` | Advanced checkbox with custom UI mapping. |
| 11 | `email` | Email validation and keyboard. |
| 12 | `vehicleNumber`| Vehicle registration number validation. |
| 14 | `attachment` | Image/File picker upload. |
| 15 | `password` | Obscured text field. |
| 16 | `pageBreak` | Visual spacing/breaks. |
| 18 | `sectionSplitter`| Bold UI header for sections. |

## Additional Information ℹ️

* **Repository:** [Form-Craft on GitHub](https://github.com/MrShakila/Form-Craft)
* **Contributions:** Pull requests and issues are welcome! Feel free to open an issue to suggest features or report bugs.
