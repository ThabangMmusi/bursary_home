import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:student_app/data/models/profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<StudentProfile?> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('profiles').doc(userId).get();
      if (doc.exists) {
        return StudentProfile.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }

  Future<void> createProfile(StudentProfile profile) async {
    try {
      await _firestore.collection('profiles').doc(profile.userId).set(profile.toFirestore());
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(StudentProfile profile) async {
    try {
      await _firestore.collection('profiles').doc(profile.userId).update(profile.toFirestore());
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<String> uploadDocument(String userId, dynamic file, String documentType) async {
    try {
      String path;
      if (documentType == 'matric_results') {
        path = 'matric_results/';
      } else if (documentType == 'id_document') {
        path = 'id_documents/';
      } else {
        throw Exception('Unsupported document type');
      }

      String fileName = '$userId';
      if (file is File) {
        fileName += '.' + file.path.split('.').last;
      } else if (file is List<int>) {
        // For web, we might not have a file path, so we'll need to infer or pass the extension
        // For now, let's assume PDF if not explicitly provided, or handle it in the bloc
        fileName += '.pdf'; // This needs to be improved if other types are expected from web
      }
      final ref = _storage.ref().child(path).child(fileName);
      UploadTask uploadTask;

      if (file is File) {
        uploadTask = ref.putFile(file);
      } else if (file is List<int>) {
        uploadTask = ref.putData(file as dynamic);
      } else {
        throw Exception('Unsupported file type');
      }

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading document: $e');
      rethrow;
    }
  }
}
