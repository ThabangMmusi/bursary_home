import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
  loading,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser user;

  const AuthState._({required this.status, this.user = AppUser.empty});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.authenticated(AppUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
