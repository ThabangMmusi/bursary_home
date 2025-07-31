part of 'bursary_bloc.dart';

enum BursaryStatus {
  initial,
  loading,
  loaded,
  error,
}

class BursaryState extends Equatable {
  final BursaryStatus status;
  final List<Bursary> bursaries; // For dashboard (limited)
  final List<Bursary> allBursaries; // For BursariesPage (full list)
  final int totalEligibleBursariesCount;
  final String? errorMessage;

  const BursaryState({
    required this.status,
    this.bursaries = const [],
    this.allBursaries = const [],
    this.totalEligibleBursariesCount = 0,
    this.errorMessage,
  });

  factory BursaryState.initial() {
    return const BursaryState(status: BursaryStatus.initial);
  }

  BursaryState copyWith({
    BursaryStatus? status,
    List<Bursary>? bursaries,
    List<Bursary>? allBursaries,
    int? totalEligibleBursariesCount,
    String? errorMessage,
  }) {
    return BursaryState(
      status: status ?? this.status,
      bursaries: bursaries ?? this.bursaries,
      allBursaries: allBursaries ?? this.allBursaries,
      totalEligibleBursariesCount: totalEligibleBursariesCount ?? this.totalEligibleBursariesCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bursaries, allBursaries, totalEligibleBursariesCount, errorMessage];
}
