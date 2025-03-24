import 'package:cloud_firestore/cloud_firestore.dart';

class FeeModel {
  String studentName;
  String id;
  bool isFeesPaid;
  int amount;
  String classNo;
  bool isChanged; // New property to track changes

  FeeModel(
      {required this.id,
      required this.studentName,
      required this.isFeesPaid,
      required this.amount,
      this.isChanged = false, // Default is false

      required this.classNo});

  void toggleStatus() {
    isFeesPaid = !isFeesPaid;
    isChanged = true; // Mark it as changed
  }

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'classNo': classNo,
      'isFeesPaid': isFeesPaid,
    };
  }

  factory FeeModel.fromFirebaseMap(String id, Map<String, dynamic> data) {
    return FeeModel(
      id: id,
      studentName: data['studentName'] ?? 'N/A',
      isFeesPaid: data['isFeesPaid'] ?? false,
      amount: data['amount'] ?? 0,
      classNo: data['classNo'] ?? 'N/A',
    );
  }

  factory FeeModel.fromFirestore(DocumentSnapshot doc) {
    return FeeModel(
      id: doc["studentId"],
      studentName: doc['studentName'],
      isFeesPaid: doc['isFeesPaid'] ?? false,
      amount: doc['amount'],
      classNo: doc['classNo'],
    );
  }
}
