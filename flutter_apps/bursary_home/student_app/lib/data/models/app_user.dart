import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photo;

  const AppUser({required this.id, this.email, this.name, this.photo});

  static const empty = AppUser(id: '');

  bool get isEmpty => this == AppUser.empty;
  bool get isNotEmpty => this != AppUser.empty;

  @override
  List<Object?> get props => [id, email, name, photo];
}
