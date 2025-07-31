import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  StreamSubscription? _profileSubscription;

  ProfileBloc({
    required ProfileRepository profileRepository,
    required FirebaseAuth firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _profileRepository = profileRepository,
       _firebaseAuth = firebaseAuth,
       _firestore = firestore ?? FirebaseFirestore.instance,
       super(ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: 'User not authenticated.',
          ),
        );
        return;
      }

      _profileSubscription?.cancel();

      _profileSubscription = _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen(
            (userDocSnapshot) async {
              double? gpa;
              bool hasCompletedProfile = false;

              if (userDocSnapshot.exists) {
                final userData = userDocSnapshot.data();
                gpa = (userData?['gpa'] as num?)?.toDouble();
                hasCompletedProfile = await _profileRepository.hasAcademicDetails(user.uid);
              }

              emit(
                state.copyWith(
                  status: ProfileStatus.loaded,
                  profile: AppUser(
                    id: user.uid,
                    gpa: gpa,
                    hasCompletedProfile: hasCompletedProfile,
                  ),
                ),
              );
            },
            onError: (error) {
              emit(
                state.copyWith(
                  status: ProfileStatus.error,
                  errorMessage: error.toString(),
                ),
              );
            },
          );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _profileRepository.updateProfile(event.profile);
      emit(
        state.copyWith(status: ProfileStatus.loaded, profile: event.profile),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
