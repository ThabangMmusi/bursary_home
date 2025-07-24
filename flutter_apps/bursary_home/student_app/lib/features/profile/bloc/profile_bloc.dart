import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_app/data/models/profile_model.dart';
import 'package:student_app/data/repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final FirebaseAuth _firebaseAuth;

  ProfileBloc({
    required ProfileRepository profileRepository,
    required FirebaseAuth firebaseAuth,
  })
      : _profileRepository = profileRepository,
        _firebaseAuth = firebaseAuth,
        super(ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        emit(state.copyWith(status: ProfileStatus.error, errorMessage: 'User not authenticated.'));
        return;
      }
      final profile = await _profileRepository.getProfile(user.uid);
      if (profile != null) {
        emit(state.copyWith(status: ProfileStatus.loaded, profile: profile));
      } else {
        // If no profile exists, create a new one
        final newProfile = StudentProfile(userId: user.uid, status: 'incomplete');
        await _profileRepository.createProfile(newProfile);
        emit(state.copyWith(status: ProfileStatus.loaded, profile: newProfile));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _profileRepository.updateProfile(event.profile);
      emit(state.copyWith(status: ProfileStatus.loaded, profile: event.profile));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()));
    }
  }
}
