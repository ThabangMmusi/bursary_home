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

  Future<void> saveCompanyProfile({
    required String companyId,
    required String taxNumber,
    required String registrationNumber,
    required String companyName,
  }) async {
    try {
      // Save basic company details
      await _firestore.collection('companies').doc(companyId).set({
        'name': companyName,
      }, SetOptions(merge: true));
      // Save additional company details
      await _firestore
          .collection('companies')
          .doc(companyId)
          .collection('more')
          .doc('details')
          .set({
        'tax_no': taxNumber,
        'reg_no': registrationNumber,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving provider profile: $e');
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
          .collection('more')
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
