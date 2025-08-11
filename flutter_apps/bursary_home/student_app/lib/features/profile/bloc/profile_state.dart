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
  final Map<String, dynamic>? academicDetails;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    this.academicDetails,
    this.errorMessage,
  });

  factory ProfileState.initial() {
    return const ProfileState(status: ProfileStatus.initial);
  }

  ProfileState copyWith({
    ProfileStatus? status,
    AppUser? profile,
    Map<String, dynamic>? academicDetails,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      academicDetails: academicDetails ?? this.academicDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, academicDetails, errorMessage];
}