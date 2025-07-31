import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:data_layer/data_layer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'applications_event.dart';
part 'applications_state.dart';

class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final ApplicationRepository _applicationRepository;
  final BursaryRepository _bursaryRepository;
  final FirebaseAuth _firebaseAuth;

  ApplicationsBloc({
    required ApplicationRepository applicationRepository,
    required BursaryRepository bursaryRepository,
    required FirebaseAuth firebaseAuth,
  }) : _applicationRepository = applicationRepository,
       _bursaryRepository = bursaryRepository,
       _firebaseAuth = firebaseAuth,
       super(ApplicationsState.initial()) {
    on<LoadApplications>(_onLoadApplications);
    on<_ApplicationsLoaded>(_onApplicationsLoaded);
    on<AddApplication>(_onAddApplication);
    on<UpdateApplication>(_onUpdateApplication);
    on<SubmitApplication>(_onSubmitApplication);
    on<CancelApplication>(_onCancelApplication);
  }

  Future<void> _onSubmitApplication(
    SubmitApplication event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(state.copyWith(status: ApplicationsStatus.loading));
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: ApplicationsStatus.error,
            errorMessage: 'User not authenticated.',
          ),
        );
        return;
      }

      final newApplication = Application(
        userId: user.uid,
        bursaryId: event.bursary.id,
        appliedDate: DateTime.now(),
        status: ApplicationStatus.pending,
        progress: 0.0,
      );

      await _applicationRepository.createApplication(newApplication);
      emit(state.copyWith(status: ApplicationsStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: ApplicationsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadApplications(
    LoadApplications event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(state.copyWith(status: ApplicationsStatus.loading));
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: ApplicationsStatus.error,
            errorMessage: 'User not authenticated.',
          ),
        );
        return;
      }
      _applicationRepository.getApplications(user.uid).listen((
        applications,
      ) async {
        final applicationsWithBursaries = await Future.wait(
          applications.map((application) async {
            final bursary = await _bursaryRepository.getBursaryById(
              application.bursaryId,
            );
            return application.copyWith(bursary: bursary);
          }),
        );
        add(_ApplicationsLoaded(applicationsWithBursaries));
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: ApplicationsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onApplicationsLoaded(
    _ApplicationsLoaded event,
    Emitter<ApplicationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: ApplicationsStatus.loaded,
        applications: event.applications,
      ),
    );
  }

  Future<void> _onAddApplication(
    AddApplication event,
    Emitter<ApplicationsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApplicationsStatus.loading));
      await _applicationRepository.createApplication(event.application);
      emit(state.copyWith(status: ApplicationsStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: ApplicationsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateApplication(
    UpdateApplication event,
    Emitter<ApplicationsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApplicationsStatus.loading));
      await _applicationRepository.updateApplication(event.application);
      emit(state.copyWith(status: ApplicationsStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: ApplicationsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Future<void> _onCancelApplication(
    CancelApplication event,
    Emitter<ApplicationsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApplicationsStatus.loading));
      final updatedApplication = event.application.copyWith(
        status: ApplicationStatus.cancelled,
      );
      await _applicationRepository.updateApplication(updatedApplication);
      emit(state.copyWith(status: ApplicationsStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: ApplicationsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
