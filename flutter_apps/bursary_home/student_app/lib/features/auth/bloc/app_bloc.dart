import 'dart:async';
import 'package:bursary_home_ui/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'package:data_layer/data_layer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/auth/bloc/app_state.dart';
import 'package:student_app/core/theme/bloc/theme_bloc.dart';
import 'package:student_app/core/theme/bloc/theme_state.dart';

part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  final ThemeBloc _themeBloc;
  late StreamSubscription<fb_auth.User?> _userSubscription;
  late StreamSubscription<ThemeState> _themeSubscription;

  AppBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required ThemeBloc themeBloc,
  }) : _authRepository = authRepository,
       _profileRepository = profileRepository,
       _themeBloc = themeBloc,
       super(AppState.unknown(themeBloc.state.themeType)) {
    on<AppUserChanged>(_onAppUserChanged);
    on<AppLogoutRequested>(_onAppLogoutRequested);
    on<AppProfileCompleted>(_onAppProfileCompleted);
    on<AppThemeChanged>(_onAppThemeChanged);

    _userSubscription = _authRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );

    _themeSubscription = _themeBloc.stream.listen(
      (themeState) => add(AppThemeChanged(themeState.themeType)),
    );
  }

  Future<void> _onAppUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) async {
    String? firstName;
    String? lastName;
    double? gpa;
    bool hasCompletedProfile = false;

    if (event.user != null) {
      emit(AppState.loading(state.themeType));
      // Fetch StudentProfile to get GPA, name, and surname
      final studentProfile = await _profileRepository.getProfile(
        event.user!.uid,
      );
      gpa = studentProfile?.gpa;
      firstName = studentProfile?.name;
      lastName = studentProfile?.surname;

      // If name/surname not from profile, try to get from auth provider display name
      if (firstName == null &&
          lastName == null &&
          event.user?.displayName != null) {
        String cleanedDisplayName = event.user!.displayName!.replaceAll(
          RegExp(r'\s*\(.*?\)\s*'),
          '',
        );
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
      hasCompletedProfile = await _profileRepository.hasAcademicDetails(
        event.user!.uid,
      );

      emit(
        AppState.authenticated(
          AppUser(
            id: event.user!.uid,
            email: event.user!.email,
            name: firstName,
            surname: lastName,
            photo: event.user!.photoURL,
            gpa: gpa,
            hasCompletedProfile: hasCompletedProfile,
          ),
          state.themeType,
        ),
      );
    } else {
      emit(AppState.unauthenticated(state.themeType));
    }
  }

  Future<void> _onAppLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) async {
    await _authRepository.signOut();
  }

  Future<void> _onAppProfileCompleted(
    AppProfileCompleted event,
    Emitter<AppState> emit,
  ) async {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      await _onAppUserChanged(AppUserChanged(currentUser), emit);
    }
  }

  Future<void> _onAppThemeChanged(
    AppThemeChanged event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(themeType: event.themeType));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _themeSubscription.cancel();
    return super.close();
  }
}
