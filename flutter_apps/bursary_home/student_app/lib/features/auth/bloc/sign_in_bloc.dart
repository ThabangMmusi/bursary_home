import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:student_app/data/repositories/auth_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignInState.initial()) {
    on<SignInGoogleRequested>(_onSignInGoogleRequested);
    on<SignInMicrosoftRequested>(_onSignInMicrosoftRequested);
  }

  Future<void> _onSignInGoogleRequested(
      SignInGoogleRequested event, Emitter<SignInState> emit) async {
    emit(state.copyWith(status: SignInStatus.loading));
    try {
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(status: SignInStatus.success));
    } on AuthException catch (e) {
      emit(state.copyWith(status: SignInStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: SignInStatus.failure, errorMessage: 'An unknown error occurred.'));
    }
  }

  Future<void> _onSignInMicrosoftRequested(
      SignInMicrosoftRequested event, Emitter<SignInState> emit) async {
    emit(state.copyWith(status: SignInStatus.loading));
    try {
      await _authRepository.signInWithMicrosoft();
      emit(state.copyWith(status: SignInStatus.success));
    } on AuthException catch (e) {
      emit(state.copyWith(status: SignInStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: SignInStatus.failure, errorMessage: 'An unknown error occurred.'));
    }
  }
}
