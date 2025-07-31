import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? surname;
  final String? photo;
  final double? gpa;
  final bool hasCompletedProfile;

  const AppUser({
    required this.id,
    this.email,
    this.name,
    this.surname,
    this.photo,
    this.gpa,
    this.hasCompletedProfile = false,
  });

  static const empty = AppUser(id: '');

  bool get isEmpty => this == AppUser.empty;
  bool get isNotEmpty => this != AppUser.empty;

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? surname,
    String? photo,
    double? gpa,
    bool? hasCompletedProfile,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      photo: photo ?? this.photo,
      gpa: gpa ?? this.gpa,
      hasCompletedProfile: hasCompletedProfile ?? this.hasCompletedProfile,
    );
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] as String?,
      name: data['name'] as String?,
      surname: data['surname'] as String?,
      photo: data['photo'] as String?,
      gpa: (data['gpa'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (surname != null) 'surname': surname,
      if (photo != null) 'photo': photo,
      if (gpa != null) 'gpa': gpa,
    };
  }

  @override
  List<Object?> get props => [id, email, name, surname, photo, gpa, hasCompletedProfile];
}