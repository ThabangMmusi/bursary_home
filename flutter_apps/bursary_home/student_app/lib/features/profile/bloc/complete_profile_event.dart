part of 'complete_profile_bloc.dart';

abstract class CompleteProfileEvent extends Equatable {
  const CompleteProfileEvent();

  @override
  List<Object> get props => [];
}

class ManualEntrySelected extends CompleteProfileEvent {}

class AIScanInitiated extends CompleteProfileEvent {}

class SubjectAdded extends CompleteProfileEvent {}

class SubjectRemoved extends CompleteProfileEvent {
  const SubjectRemoved(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class QualificationNameChanged extends CompleteProfileEvent {
  const QualificationNameChanged(this.qualificationName);

  final String qualificationName;

  @override
  List<Object> get props => [qualificationName];
}

class SubjectNameChanged extends CompleteProfileEvent {
  const SubjectNameChanged(this.index, this.name);

  final int index;
  final String name;

  @override
  List<Object> get props => [index, name];
}

class SubjectMarksChanged extends CompleteProfileEvent {
  const SubjectMarksChanged(this.index, this.marks);

  final int index;
  final int marks;

  @override
  List<Object> get props => [index, marks];
}

class SubjectLevelChanged extends CompleteProfileEvent {
  const SubjectLevelChanged(this.index, this.level);

  final int index;
  final String level;

  @override
  List<Object> get props => [index, level];
}

class NameChanged extends CompleteProfileEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class SurnameChanged extends CompleteProfileEvent {
  const SurnameChanged(this.surname);

  final String surname;

  @override
  List<Object> get props => [surname];
}

class FormSubmitted extends CompleteProfileEvent {}
