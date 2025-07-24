part of 'bursary_bloc.dart';

abstract class BursaryEvent extends Equatable {
  const BursaryEvent();

  @override
  List<Object> get props => [];
}

class LoadBursaries extends BursaryEvent {
  final List<Bursary> bursaries;

  const LoadBursaries(this.bursaries);

  @override
  List<Object> get props => [bursaries];
}
