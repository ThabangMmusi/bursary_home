part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInGoogleRequested extends SignInEvent {}

class SignInMicrosoftRequested extends SignInEvent {}
