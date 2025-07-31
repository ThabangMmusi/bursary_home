import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';
import 'package:student_app/features/auth/bloc/auth_state.dart';

part 'bursary_event.dart';
part 'bursary_state.dart';

class BursaryBloc extends Bloc<BursaryEvent, BursaryState> {
  final BursaryRepository _bursaryRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _bursariesSubscription;
  StreamSubscription? _authSubscription;

  BursaryBloc({
    required BursaryRepository bursaryRepository,
    required AuthBloc authBloc,
  }) : _bursaryRepository = bursaryRepository,
       _authBloc = authBloc,
       super(BursaryState.initial()) {
    on<LoadStudentDashboardBursaries>(_onLoadStudentDashboardBursaries);
    on<LoadStudentBursaries>(_onLoadStudentBursaries);

    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState.status == AuthStatus.authenticated) {
        // Only load dashboard bursaries if not already loaded or if user changes
        if (state.status == BursaryStatus.initial || state.status == BursaryStatus.error) {
          add(LoadStudentDashboardBursaries());
        }
      } else {
        _bursariesSubscription?.cancel();
        emit(BursaryState.initial());
      }
    });

    // Initial load of bursaries if user is already authenticated and bloc is initial
    if (_authBloc.state.status == AuthStatus.authenticated && state.status == BursaryStatus.initial) {
      add(LoadStudentDashboardBursaries());
    }
  }

  Future<void> _onLoadStudentDashboardBursaries(
    LoadStudentDashboardBursaries event,
    Emitter<BursaryState> emit,
  ) async {
    _bursariesSubscription?.cancel(); // Cancel any previous subscription

    final user = _authBloc.state.user;
    if (user.gpa == null) {
      emit(
        state.copyWith(
          status: BursaryStatus.loaded,
          bursaries: [],
          errorMessage: 'User GPA not available.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: BursaryStatus.loading),
    ); // Indicate loading state

    await emit.onEach(
      _bursaryRepository.loadStudentDashboardBursaries(user.id, user.gpa!),
      onData: (bursaries) async {
        final totalCount = await _bursaryRepository.getEligibleBursariesCount(user.id, user.gpa!); // Fetch total count
        emit(
          state.copyWith(status: BursaryStatus.loaded, bursaries: bursaries, totalEligibleBursariesCount: totalCount),
        );
        print('Dashboard Bursaries Length: ${bursaries.length}');
        print('Total Eligible Bursaries Count: ${totalCount}');
      },
      onError: (error, stackTrace) {
        emit(
          state.copyWith(
            status: BursaryStatus.error,
            errorMessage: 'Error loading bursaries: $error',
          ),
        );
        print('BursaryBloc Error: $error\n$stackTrace');
      },
    );
  }

  Future<void> _onLoadStudentBursaries(
    LoadStudentBursaries event,
    Emitter<BursaryState> emit,
  ) async {
    _bursariesSubscription?.cancel(); // Cancel any previous subscription

    final user = _authBloc.state.user;
    if (user.gpa == null) {
      emit(
        state.copyWith(
          status: BursaryStatus.loaded,
          bursaries: [],
          errorMessage: 'User GPA not available.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: BursaryStatus.loading),
    ); // Indicate loading state

    await emit.onEach(
      _bursaryRepository.loadStudentBursaries(user.id, user.gpa!),
      onData: (bursaries) {
        emit(
          state.copyWith(status: BursaryStatus.loaded, allBursaries: bursaries),
        );
      },
      onError: (error, stackTrace) {
        emit(
          state.copyWith(
            status: BursaryStatus.error,
            errorMessage: 'Error loading bursaries: $error',
          ),
        );
        print('BursaryBloc Error: $error\n$stackTrace');
      },
    );
  }

  @override
  Future<void> close() {
    _bursariesSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}