import 'package:equatable/equatable.dart';

class Provider extends Equatable {
  final String id;
  final String? name;
  final String? registrationNumber;
  final String? taxNumber;

  const Provider({
    required this.id,
    this.name,
    this.registrationNumber,
    this.taxNumber,
  });

  factory Provider.fromFirestore(Map<String, dynamic> data, String id) {
    return Provider(
      id: id,
      name: data['name'] as String?,
      registrationNumber: data['registrationNumber'] as String?,
      taxNumber: data['taxNumber'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) 'name': name,
      if (registrationNumber != null) 'registrationNumber': registrationNumber,
      if (taxNumber != null) 'taxNumber': taxNumber,
    };
  }

  @override
  List<Object?> get props => [id, name, registrationNumber, taxNumber];
}