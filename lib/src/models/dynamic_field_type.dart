/// Represents a type of field in a dynamic form.
enum DynamicFieldType {
  text(1),
  dateTime(2),
  checkbox(3),
  number(5),
  dropdown(6),
  phoneNumber(7),
  textArea(8),
  radio(9),
  checkText(10),
  email(11),
  vehicleNumber(12),
  // document(13),
  attachment(14),
  password(15),
  pageBreak(16),
  // smileyType(17),
  sectionSplitter(18);

  final int _id;
  const DynamicFieldType(this._id);
  int get id => _id;

  /// Finds the enum value associated with the given [id].
  ///
  /// Throws an [ArgumentError] if no matching enum value is found.
  // static DynamicFieldType fromId(int id) {
  //   return DynamicFieldType.values.firstWhere(
  //     (type) => type.id == id,
  //     orElse: () =>
  //         throw ArgumentError('No DynamicFieldType found for ID: $id'),
  //   );
  // }

  /// Safely finds the enum value associated with the given [id].
  ///
  /// Returns `null` if no matching enum value is found.
  static DynamicFieldType? tryFromId(int id) {
    for (final type in DynamicFieldType.values) {
      if (type.id == id) {
        return type;
      }
    }
    return null; // No match found
  }
}

/// Extension providing helper getters for form field types.
extension DynamicFieldTypeExtension on DynamicFieldType {
  /// Provides a user-friendly, readable name for each field type.
  String get displayName {
    switch (this) {
      case DynamicFieldType.text:
        return 'Text';
      case DynamicFieldType.dateTime:
        return 'Date & Time';
      case DynamicFieldType.checkbox:
        return 'Checkbox';
      case DynamicFieldType.number:
        return 'Number';
      case DynamicFieldType.dropdown:
        return 'Dropdown';
      case DynamicFieldType.phoneNumber:
        return 'Phone Number';
      case DynamicFieldType.textArea:
        return 'Text Area';
      case DynamicFieldType.radio:
        return 'Radio Button';
      case DynamicFieldType.checkText:
        return 'Checkbox with Text';
      case DynamicFieldType.email:
        return 'Email';
      case DynamicFieldType.vehicleNumber:
        return 'Vehicle Number';
      // case DynamicFieldType.document:
      //   return 'Document Upload';
      case DynamicFieldType.attachment:
        return 'File Attachment';
      case DynamicFieldType.password:
        return 'Password';
      case DynamicFieldType.pageBreak:
        return 'Page Break';
      // case DynamicFieldType.smileyType:
      //   return 'Smiley Rating';
      case DynamicFieldType.sectionSplitter:
        return 'Section Splitter';
    }
  }

  /// A helper to determine if the field is a user-input field
  /// or a purely visual/structural element.
  bool get isInputElement {
    switch (this) {
      case DynamicFieldType.pageBreak:
      case DynamicFieldType.sectionSplitter:
        return false;
      default:
        return true; // All other types collect data
    }
  }

  /// A helper to determine if the field type requires a list of options
  /// (e.g., for a dropdown or radio group).
  bool get requiresOptions {
    switch (this) {
      case DynamicFieldType.dropdown:
      case DynamicFieldType.radio:
      case DynamicFieldType.checkText: // Assuming this is a list of options
        return true;
      default:
        return false;
    }
  }
}
