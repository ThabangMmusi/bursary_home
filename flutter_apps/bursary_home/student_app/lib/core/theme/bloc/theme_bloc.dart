import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/core/theme/bloc/theme_event.dart';
import 'package:student_app/core/theme/bloc/theme_state.dart';
import 'package:student_app/core/theme/theme_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemePreferences _themePreferences;

  ThemeBloc({required ThemePreferences themePreferences})
      : _themePreferences = themePreferences,
        super(ThemeState.initial()) {
    on<ThemeStarted>(_onThemeStarted);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeStarted(
    ThemeStarted event,
    Emitter<ThemeState> emit,
  ) async {
    final savedThemeType = await _themePreferences.getTheme();
    emit(state.copyWith(
      themeType: savedThemeType,
      themeData: savedThemeType == ThemeType.student
          ? AppTheme.studentTheme
          : AppTheme.providerTheme,
    ));
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await _themePreferences.saveTheme(event.themeType);
    emit(state.copyWith(
      themeType: event.themeType,
      themeData: event.themeType == ThemeType.student
          ? AppTheme.studentTheme
          : AppTheme.providerTheme,
    ));
  }
}
