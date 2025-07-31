import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'package:data_layer/data_layer.dart';
import 'package:student_app/features/auth/bloc/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  late StreamSubscription<fb_auth.User?> _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  })
      : _authRepository = authRepository,
        _profileRepository = profileRepository,
        super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthProfileCompleted>(_onAuthProfileCompleted);

    _userSubscription = _authRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  Future<void> _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) async {
    String? firstName;
    String? lastName;
    double? gpa;
    bool hasCompletedProfile = false;

    if (event.user != null) {
      emit(const AuthState.loading());
      // Fetch StudentProfile to get GPA, name, and surname
      final studentProfile = await _profileRepository.getProfile(event.user!.uid);
      gpa = studentProfile?.gpa;
      firstName = studentProfile?.name;
      lastName = studentProfile?.surname;

      // If name/surname not from profile, try to get from auth provider display name
      if (firstName == null && lastName == null && event.user?.displayName != null) {
        String cleanedDisplayName = event.user!.displayName!.replaceAll(RegExp(r'\s*\(.*?\)\s*'), '');
        final parts = cleanedDisplayName.split(' ');
        if (parts.isNotEmpty) {
          if (parts.length > 1) {
            firstName = parts.sublist(0, parts.length - 1).join(' ');
            lastName = parts.last;
          } else {
            firstName = parts[0];
            lastName = null;
          }
        }
      }

      // Check for academic details to determine profile completion
      hasCompletedProfile = await _profileRepository.hasAcademicDetails(event.user!.uid);

      emit(AuthState.authenticated(AppUser(
        id: event.user!.uid,
        email: event.user!.email,
        name: firstName,
        surname: lastName,
        photo: event.user!.photoURL,
        gpa: gpa,
        hasCompletedProfile: hasCompletedProfile,
      )));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
  }

  Future<void> _onAuthProfileCompleted(
      AuthProfileCompleted event, Emitter<AuthState> emit) async {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      await _onAuthUserChanged(AuthUserChanged(currentUser), emit);
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
