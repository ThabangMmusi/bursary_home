import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_app/data/models/bursary_model.dart';
import 'package:student_app/data/repositories/bursary_repository.dart';

part 'bursary_event.dart';
part 'bursary_state.dart';

class BursaryBloc extends Bloc<BursaryEvent, BursaryState> {
  final BursaryRepository _bursaryRepository;
  late StreamSubscription _bursariesSubscription;

  BursaryBloc({required BursaryRepository bursaryRepository})
      : _bursaryRepository = bursaryRepository,
        super(BursaryState.initial()) {
    on<LoadBursaries>(_onLoadBursaries);

    _bursariesSubscription = _bursaryRepository.getBursaries().listen(
          (bursaries) => add(LoadBursaries(bursaries)),
        );
  }

  void _onLoadBursaries(LoadBursaries event, Emitter<BursaryState> emit) {
    emit(state.copyWith(
      status: BursaryStatus.loaded,
      bursaries: event.bursaries,
    ));
  }

  @override
  Future<void> close() {
    _bursariesSubscription.cancel();
    return super.close();
  }
}
