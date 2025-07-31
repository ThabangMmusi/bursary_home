part of 'complete_profile_bloc.dart';

enum CompleteProfileEntryMode { none, manual, ai }

class CompleteProfileState extends Equatable {
  const CompleteProfileState({
    this.entryMode = CompleteProfileEntryMode.none,
    this.subjects = const [],
    this.qualificationName = '',
    this.name = '',
    this.surname = '',
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.submissionError = false,
  });

  final CompleteProfileEntryMode entryMode;
  final List<Subject> subjects;
  final String qualificationName;
  final String name;
  final String surname;
  final bool isSubmitting;
  final bool submissionSuccess;
  final bool submissionError;

  CompleteProfileState copyWith({
    CompleteProfileEntryMode? entryMode,
    List<Subject>? subjects,
    String? qualificationName,
    String? name,
    String? surname,
    bool? isSubmitting,
    bool? submissionSuccess,
    bool? submissionError,
  }) {
    return CompleteProfileState(
      entryMode: entryMode ?? this.entryMode,
      subjects: subjects ?? this.subjects,
      qualificationName: qualificationName ?? this.qualificationName,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      submissionError: submissionError ?? this.submissionError,
    );
  }

  @override
  List<Object> get props => [
        entryMode,
        subjects,
        qualificationName,
        name,
        surname,
        isSubmitting,
        submissionSuccess,
        submissionError,
      ];
}
