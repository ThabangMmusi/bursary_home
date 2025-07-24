import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_app/data/models/application_model.dart';
import 'package:student_app/data/repositories/application_repository.dart';

part 'applications_event.dart';
part 'applications_state.dart';

class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final ApplicationRepository _applicationRepository;
  final FirebaseAuth _firebaseAuth;
  StreamSubscription? _applicationsSubscription;

  ApplicationsBloc({
    required ApplicationRepository applicationRepository,
    required FirebaseAuth firebaseAuth,
  })
      : _applicationRepository = applicationRepository,
        _firebaseAuth = firebaseAuth,
        super(ApplicationsState.initial()) {
    on<LoadApplications>(_onLoadApplications);
    on<AddApplication>(_onAddApplication);
    on<UpdateApplication>(_onUpdateApplication);

    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _applicationsSubscription = _applicationRepository
            .getApplications(user.uid)
            .listen((applications) {
          add(LoadApplications(applications));
        });
      } else {
        _applicationsSubscription?.cancel();
        emit(ApplicationsState.initial());
      }
    });
  }

  void _onLoadApplications(
      LoadApplications event, Emitter<ApplicationsState> emit) {
    emit(state.copyWith(
      status: ApplicationsStatus.loaded,
      applications: event.applications,
    ));
  }

  Future<void> _onAddApplication(
      AddApplication event, Emitter<ApplicationsState> emit) async {
    try {
      emit(state.copyWith(status: ApplicationsStatus.loading));
      await _applicationRepository.createApplication(event.application);
      emit(state.copyWith(status: ApplicationsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          status: ApplicationsStatus.error,
          errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateApplication(
      UpdateApplication event, Emitter<ApplicationsState> emit) async {
    try {
      emit(state.copyWith(status: ApplicationsStatus.loading));
      await _applicationRepository.updateApplication(event.application);
      emit(state.copyWith(status: ApplicationsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          status: ApplicationsStatus.error,
          errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _applicationsSubscription?.cancel();
    return super.close();
  }
}
