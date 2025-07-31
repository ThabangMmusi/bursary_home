part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final AppUser? profile;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  factory ProfileState.initial() {
    return const ProfileState(status: ProfileStatus.initial);
  }

  ProfileState copyWith({
    ProfileStatus? status,
    AppUser? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}