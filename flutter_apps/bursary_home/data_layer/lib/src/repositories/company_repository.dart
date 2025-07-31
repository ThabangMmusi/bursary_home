import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyRepository {
  final FirebaseFirestore _firestore;

  CompanyRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String?> getCompanyName(String companyId) async {
    try {
      final doc = await _firestore.collection('companies').doc(companyId).get();
      if (doc.exists) {
        return doc.data()?['name'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting company name: $e');
      return null;
    }
  }
}
