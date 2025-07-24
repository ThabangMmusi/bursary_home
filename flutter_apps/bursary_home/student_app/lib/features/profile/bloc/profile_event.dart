part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final StudentProfile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object> get props => [profile];
}
