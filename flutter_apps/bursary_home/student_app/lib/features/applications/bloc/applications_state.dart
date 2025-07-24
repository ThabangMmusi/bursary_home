part of 'applications_bloc.dart';

enum ApplicationsStatus {
  initial,
  loading,
  loaded,
  error,
}

class ApplicationsState extends Equatable {
  final ApplicationsStatus status;
  final List<Application> applications;
  final String? errorMessage;

  const ApplicationsState({
    required this.status,
    this.applications = const [],
    this.errorMessage,
  });

  factory ApplicationsState.initial() {
    return const ApplicationsState(status: ApplicationsStatus.initial);
  }

  ApplicationsState copyWith({
    ApplicationsStatus? status,
    List<Application>? applications,
    String? errorMessage,
  }) {
    return ApplicationsState(
      status: status ?? this.status,
      applications: applications ?? this.applications,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, applications, errorMessage];
}
