part of 'sign_in_bloc.dart';

enum SignInStatus {
  initial,
  loading,
  success,
  failure,
}

class SignInState extends Equatable {
  final SignInStatus status;
  final String? errorMessage;

  const SignInState({required this.status, this.errorMessage});

  factory SignInState.initial() {
    return const SignInState(status: SignInStatus.initial);
  }

  SignInState copyWith({
    SignInStatus? status,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
