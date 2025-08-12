import 'package:bursary_home_ui/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';

enum AppStatus { authenticated, unauthenticated, unknown, loading }

class AppState extends Equatable {
  final AppStatus status;
  final AppUser user;
  final ThemeType themeType;

  const AppState._({
    required this.status,
    this.user = AppUser.empty,
    required this.themeType,
  });

  const AppState.unknown(ThemeType themeType)
    : this._(status: AppStatus.unknown, themeType: themeType);

  const AppState.loading(ThemeType themeType)
    : this._(status: AppStatus.loading, themeType: themeType);

  const AppState.authenticated(AppUser user, ThemeType themeType)
    : this._(status: AppStatus.authenticated, user: user, themeType: themeType);

  const AppState.unauthenticated(ThemeType themeType)
    : this._(status: AppStatus.unauthenticated, themeType: themeType);

  bool get isStudent => themeType == ThemeType.student;

  AppState copyWith({AppStatus? status, AppUser? user, ThemeType? themeType}) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      themeType: themeType ?? this.themeType,
    );
  }

  @override
  List<Object> get props => [status, user, themeType];
}
