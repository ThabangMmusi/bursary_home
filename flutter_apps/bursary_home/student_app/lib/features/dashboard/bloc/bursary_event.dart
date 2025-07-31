part of 'bursary_bloc.dart';

abstract class BursaryEvent extends Equatable {
  const BursaryEvent();

  @override
  List<Object> get props => [];
}

class LoadStudentDashboardBursaries extends BursaryEvent {}

class LoadStudentBursaries extends BursaryEvent {}