enum FormStatus {
  submitted(1),
  draft(0),
  pending(2);

  final int _id;
  const FormStatus(this._id);
  int get id => _id;

  /// Returns `null` if no matching enum value is found.
  static FormStatus? tryFromId(int? id) {
    for (final type in FormStatus.values) {
      if (type.id == id) {
        return type;
      }
    }
    return null; // No match found
  }
}

extension FormStatusLabel on FormStatus {
  String get label {
    switch (this) {
      case FormStatus.draft:
        return 'Draft';
      case FormStatus.submitted:
        return 'Submitted';
      case FormStatus.pending:
        return "Pending";
    }
  }
}
