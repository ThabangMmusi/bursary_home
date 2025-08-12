import 'package:equatable/equatable.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:bursary_home_ui/enums.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeStarted extends ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final ThemeType themeType;

  const ThemeChanged(this.themeType);

  @override
  List<Object> get props => [themeType];
}
