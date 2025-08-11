part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppUserChanged extends AppEvent {
  final fb_auth.User? user;

  const AppUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AppLogoutRequested extends AppEvent {}

class AppProfileCompleted extends AppEvent {}

class AppThemeChanged extends AppEvent {
  final ThemeType themeType;

  const AppThemeChanged(this.themeType);

  @override
  List<Object> get props => [themeType];
}
