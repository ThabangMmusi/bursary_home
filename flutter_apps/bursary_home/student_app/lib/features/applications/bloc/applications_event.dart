part of 'applications_bloc.dart';

abstract class ApplicationsEvent extends Equatable {
  const ApplicationsEvent();

  @override
  List<Object> get props => [];
}

class LoadApplications extends ApplicationsEvent {
  const LoadApplications();
}

class _ApplicationsLoaded extends ApplicationsEvent {
  final List<Application> applications;

  const _ApplicationsLoaded(this.applications);

  @override
  List<Object> get props => [applications];
}

class AddApplication extends ApplicationsEvent {
  final Application application;

  const AddApplication(this.application);

  @override
  List<Object> get props => [application];
}

class UpdateApplication extends ApplicationsEvent {
  final Application application;

  const UpdateApplication(this.application);

  @override
  List<Object> get props => [application];
}

class SubmitApplication extends ApplicationsEvent {
  final Bursary bursary;

  const SubmitApplication(this.bursary);

  @override
  List<Object> get props => [bursary];
}

class CancelApplication extends ApplicationsEvent {
  final Application application;

  const CancelApplication(this.application);

  @override
  List<Object> get props => [application];
}
