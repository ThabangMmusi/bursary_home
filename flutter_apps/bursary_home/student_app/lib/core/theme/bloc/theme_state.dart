import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/core/theme/theme_preferences.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;
  final ThemeType themeType;

  const ThemeState({required this.themeData, required this.themeType});

  factory ThemeState.initial() {
    return ThemeState(
      themeData: AppTheme.studentTheme,
      themeType: ThemeType.student,
    );
  }

  ThemeState copyWith({ThemeData? themeData, ThemeType? themeType}) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      themeType: themeType ?? this.themeType,
    );
  }

  @override
  List<Object> get props => [themeData, themeType];
}
