part of 'applications_bloc.dart';

abstract class ApplicationsEvent extends Equatable {
  const ApplicationsEvent();

  @override
  List<Object> get props => [];
}

class LoadApplications extends ApplicationsEvent {
  final List<Application> applications;

  const LoadApplications(this.applications);

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
