import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_layer/models.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AppUser?> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }

  Future<void> createProfile(AppUser profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toFirestore());
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(AppUser profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .update(profile.toFirestore());
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> saveCompleteProfile({
    required String id,
    required double gpa,
    String? name,
    String? surname,
  }) async {
    try {
      await _firestore.collection('users').doc(id).set({
        'gpa': gpa,
        'name': name,
        'surname': surname,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving complete profile: $e');
      rethrow;
    }
  }

  Future<void> saveAcademicDetails({
    required String id,
    required String qualificationName,
    required List<Subject> subjects,
  }) async {
    try {
      final subjectsData = subjects
          .map((s) => {
                'name': s.name,
                'marks': s.marks,
              })
          .toList();

      await _firestore
          .collection('users')
          .doc(id)
          .collection('more_details')
          .doc('academics')
          .set({
        'qualificationName': qualificationName,
        'subjects': subjectsData,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving academic details: $e');
      rethrow;
    }
  }

  Future<bool> hasAcademicDetails(String id) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(id)
          .collection('more_details')
          .doc('academics')
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking academic details: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getAcademicDetails(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('more_details')
          .doc('academics')
          .get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting academic details: $e');
      rethrow;
    }
  }
}
