part of 'bursary_bloc.dart';

enum BursaryStatus {
  initial,
  loading,
  loaded,
  error,
}

class BursaryState extends Equatable {
  final BursaryStatus status;
  final List<Bursary> bursaries;
  final String? errorMessage;

  const BursaryState({
    required this.status,
    this.bursaries = const [],
    this.errorMessage,
  });

  factory BursaryState.initial() {
    return const BursaryState(status: BursaryStatus.initial);
  }

  BursaryState copyWith({
    BursaryStatus? status,
    List<Bursary>? bursaries,
    String? errorMessage,
  }) {
    return BursaryState(
      status: status ?? this.status,
      bursaries: bursaries ?? this.bursaries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bursaries, errorMessage];
}
