import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';
import 'package:uuid/uuid.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final ProfileRepository _profileRepository;
  final AppBloc _appBloc;

  CompleteProfileBloc({
    required ProfileRepository profileRepository,
    required AppBloc appBloc,
  }) : _profileRepository = profileRepository,
       _appBloc = appBloc,
       super(const CompleteProfileState()) {
    on<ManualEntrySelected>((event, emit) {
      emit(state.copyWith(entryMode: CompleteProfileEntryMode.manual));
    });

    on<AIScanInitiated>((event, emit) {
      emit(state.copyWith(entryMode: CompleteProfileEntryMode.ai));
    });

    on<SubjectAdded>((event, emit) {
      final newSubject = Subject(name: '', marks: 0, level: '1');
      emit(
        state.copyWith(subjects: List.from(state.subjects)..add(newSubject)),
      );
    });

    on<SubjectRemoved>((event, emit) {
      emit(
        state.copyWith(
          subjects: List.from(state.subjects)..removeAt(event.index),
        ),
      );
    });

    on<QualificationNameChanged>((event, emit) {
      emit(state.copyWith(qualificationName: event.qualificationName));
    });

    on<SubjectNameChanged>((event, emit) {
      final subjects = List<Subject>.from(state.subjects);
      subjects[event.index] = Subject(
        name: event.name,
        marks: subjects[event.index].marks,
        level: subjects[event.index].level,
      );
      emit(state.copyWith(subjects: subjects));
    });

    on<SubjectMarksChanged>((event, emit) {
      final subjects = List<Subject>.from(state.subjects);
      subjects[event.index] = Subject(
        name: subjects[event.index].name,
        marks: event.marks,
        level: subjects[event.index].level,
      );
      emit(state.copyWith(subjects: subjects));
    });

    on<SubjectLevelChanged>((event, emit) {
      final subjects = List<Subject>.from(state.subjects);
      subjects[event.index] = Subject(
        name: subjects[event.index].name,
        marks: subjects[event.index].marks,
        level: event.level,
      );
      emit(state.copyWith(subjects: subjects));
    });

    on<NameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<SurnameChanged>((event, emit) {
      emit(state.copyWith(surname: event.surname));
    });

    on<CompanyNameChanged>((event, emit) {
      emit(state.copyWith(companyName: event.companyName));
    });

    on<RegistrationNumberChanged>((event, emit) {
      emit(state.copyWith(registrationNumber: event.registrationNumber));
    });

    on<TaxNumberChanged>((event, emit) {
      emit(state.copyWith(taxNumber: event.taxNumber));
    });

    on<FormSubmitted>((event, emit) async {
      emit(
        state.copyWith(
          isSubmitting: true,
          submissionError: false,
          submissionSuccess: false,
        ),
      );
      try {
        final userId = _appBloc.state.user.id;

        AppUser newUser = AppUser(
          id: userId,
          email: _appBloc.state.user.email,
          name: state.name,
          surname: state.surname,
          photo: _appBloc.state.user.photo,
        );
        if (_appBloc.state.isStudent) {
          final gpa = _calculateGpa(state.subjects);
          final newStudent = newUser.copyWith(gpa: gpa);

          await _profileRepository.createProfile(newStudent);
          await _profileRepository.saveAcademicDetails(
            id: userId,
            qualificationName: state.qualificationName,
            subjects: state.subjects,
          );
        } else {
          final companyId = Uuid().v4();
          final newProvider = newUser.copyWith(companyId: companyId);

          await _profileRepository.createProfile(newProvider);
          await _profileRepository.saveCompanyProfile(
            companyId: companyId,
            taxNumber: state.taxNumber,
            registrationNumber: state.registrationNumber,
            companyName: state.companyName,
          );
        }
        emit(state.copyWith(isSubmitting: false, submissionSuccess: true));
        _appBloc.add(AppProfileCompleted());
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, submissionError: true));
      }
    });
  }

  double _calculateGpa(List<Subject> subjects) {
    if (subjects.isEmpty) {
      return 0.0;
    }

    double totalPoints = 0;
    for (var subject in subjects) {
      if (subject.marks >= 75) {
        totalPoints += 7;
      } else if (subject.marks >= 70) {
        totalPoints += 6;
      } else if (subject.marks >= 60) {
        totalPoints += 5;
      } else if (subject.marks >= 50) {
        totalPoints += 4;
      } else if (subject.marks >= 40) {
        totalPoints += 3;
      } else if (subject.marks >= 30) {
        totalPoints += 2;
      } else {
        totalPoints += 1;
      }
    }
    return totalPoints / subjects.length;
  }
}
