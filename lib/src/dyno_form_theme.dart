import 'package:flutter/material.dart';

class DynoFormStyle {
  final Color? errorFillColor;
  final Color? successFillColor;
  final Color? mandatoryStarColor;
  final ButtonStyle? submitButtonStyle;
  final TextStyle? sectionTitleStyle;
  final InputDecorationTheme? inputDecorationTheme;

  const DynoFormStyle({
    this.errorFillColor,
    this.successFillColor,
    this.mandatoryStarColor,
    this.submitButtonStyle,
    this.sectionTitleStyle,
    this.inputDecorationTheme,
  });
}

class DynoFormTheme extends InheritedWidget {
  final DynoFormStyle style;

  const DynoFormTheme({
    super.key,
    required this.style,
    required super.child,
  });

  static DynoFormStyle of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<DynoFormTheme>();
    return theme?.style ?? const DynoFormStyle();
  }

  @override
  bool updateShouldNotify(DynoFormTheme oldWidget) => style != oldWidget.style;
}
