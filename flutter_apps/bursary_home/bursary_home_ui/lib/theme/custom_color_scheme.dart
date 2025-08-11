import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get success => this.secondary;
  Color get onSuccess => this.onSecondary;
  Color get warning => this.tertiary;
  Color get onWarning => this.onTertiary;
  Color get info => this.primary;
  Color get onInfo => this.onPrimary;
}
