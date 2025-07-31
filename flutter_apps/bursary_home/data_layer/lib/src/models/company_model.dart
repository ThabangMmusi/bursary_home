import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String id;
  final String name;

  const Company({
    required this.id,
    required this.name,
  });

  factory Company.fromFirestore(Map<String, dynamic> data, String id) {
    return Company(
      id: id,
      name: data['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }

  @override
  List<Object> get props => [id, name];
}
