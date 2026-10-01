/// Represents a specific validation rule that can be applied to a dynamic field.
enum DynamicFieldValidationType {
  na(1), // 'Not Applicable' or no specific validation
  email(2),
  phoneNumber(3),
  vehicleNumber(4),
  minLength(5),
  maxLength(6);

  final int _type;
  const DynamicFieldValidationType(this._type);
  int get type => _type;

  /// Finds the enum value associated with the given [type] ID.
  ///
  /// Throws an [ArgumentError] if no matching enum value is found.
  static DynamicFieldValidationType fromType(int typeId) {
    return DynamicFieldValidationType.values.firstWhere(
      (type) => type.type == typeId,
      orElse: () => DynamicFieldValidationType.na,
    );
  }

  /// Safely finds the enum value associated with the given [type] ID.
  ///
  static DynamicFieldValidationType? tryFromType(int? typeId) {
    for (final type in DynamicFieldValidationType.values) {
      if (type.type == typeId) {
        return type;
      }
    }
    return DynamicFieldValidationType.na; // No match found
  }
}

/// Extension providing helper getters for validation types.
extension DynamicFieldValidationTypeExtension on DynamicFieldValidationType {
  /// Provides a user-friendly, readable name for the validation rule.
  String get displayName {
    switch (this) {
      case DynamicFieldValidationType.na:
        return 'None';
      case DynamicFieldValidationType.email:
        return 'Email';
      case DynamicFieldValidationType.phoneNumber:
        return 'Phone Number';
      case DynamicFieldValidationType.vehicleNumber:
        return 'Vehicle Number';
      case DynamicFieldValidationType.minLength:
        return 'Minimum Length';
      case DynamicFieldValidationType.maxLength:
        return 'Maximum Length';
    }
  }

  /// Provides a default error message for this validation type.
  String get defaultErrorMessage {
    switch (this) {
      case DynamicFieldValidationType.na:
        return ''; // No error
      case DynamicFieldValidationType.email:
        return 'Please enter a valid email address';
      case DynamicFieldValidationType.phoneNumber:
        return 'Please enter a valid phone number';
      case DynamicFieldValidationType.vehicleNumber:
        return 'Please enter a valid vehicle number';
      case DynamicFieldValidationType.minLength:
        return 'The value must be at least {value} characters long';
      case DynamicFieldValidationType.maxLength:
        return 'The value must be at most {value} characters long';
    }
  }
}
