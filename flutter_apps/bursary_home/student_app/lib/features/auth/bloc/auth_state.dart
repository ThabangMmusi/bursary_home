import 'package:equatable/equatable.dart';
import 'package:student_app/data/models/app_user.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser user;

  const AuthState._({required this.status, this.user = AppUser.empty});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(AppUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
