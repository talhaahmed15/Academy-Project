import 'package:ahmed_academy/Models/fee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeeProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getFormattedMonth(DateTime date) =>
      DateFormat('MMM-yyyy').format(date);

  Future<bool> checkAndCopyPreviousMonthData() async {
    DateTime now = DateTime.now();
    String currentMonth = _getFormattedMonth(now);
    String previousMonth =
        _getFormattedMonth(DateTime(now.year, now.month - 1, now.day));

    try {
      final previousSnapshot = await _firestore
          .collection("FeeStatus")
          .doc(previousMonth)
          .get()
          .timeout(const Duration(seconds: 10));

      if (previousSnapshot.exists) {
        final previousData = previousSnapshot.data() as Map<String, dynamic>;
        print(previousData.length);

        final updatedData = previousData.map((key, value) {
          print(value);
          value['isFeesPaid'] = false;
          return MapEntry(key, value);
        });

        await _firestore
            .collection("FeeStatus")
            .doc(currentMonth)
            .set(updatedData, SetOptions(merge: true));

        return true;
      } else {
        print("Previous month data doesn't exist.");
        return false;
      }
    } catch (e) {
      print("Error checking previous month data: $e");
      throw Exception("$e");
    }
  }

  // ✅ Fetch current month's fee status; if not available, copy from previous month
  Future<List<FeeModel>> fetchFeeStatus() async {
    try {
      String currentMonth = _getFormattedMonth(DateTime.now());

      var snapshot = await _firestore
          .collection("FeeStatus")
          .doc(currentMonth)
          .get()
          .timeout(const Duration(seconds: 10));

      if (!snapshot.exists) {
        bool created = await checkAndCopyPreviousMonthData();

        if (!created)
          return [];
        else {
          snapshot = await _firestore
              .collection("FeeStatus")
              .doc(currentMonth)
              .get()
              .timeout(const Duration(seconds: 10));
        }
      }

      final data = snapshot.data() as Map<String, dynamic>;
      return data.entries.map((entry) {
        final student = entry.value as Map<String, dynamic>;
        return FeeModel(
          id: entry.key,
          studentName: student['studentName'] ?? 'N/A',
          classNo: student['classNo'] ?? 'N/A',
          isFeesPaid: student['isFeesPaid'] ?? false,
          amount: student['amount'] ?? 0,
        );
      }).toList();
    } catch (e) {
      print("Error fetching fee status: $e");

      throw Exception("$e");
    }
  }

  Future<void> saveFeeStatus(List<FeeModel> feeStatusList) async {
    try {
      String currentMonth = _getFormattedMonth(DateTime.now());
      DocumentReference feeRef =
          FirebaseFirestore.instance.collection('FeeStatus').doc(currentMonth);

      // Convert the list of FeeModel into a map with student IDs as keys
      Map<String, dynamic> feeData = {
        for (var feeModel in feeStatusList) feeModel.id: feeModel.toMap(),
      };

      // Update the entire document with the new fee data
      await feeRef.set(
          feeData,
          SetOptions(
              merge: true)); // merge:true to avoid overwriting other fields
    } catch (e) {
      throw Exception("Error saving fee status: $e");
    }
  }

  Future<Map<String, List<FeeModel>>> fetchFeeHistory() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("FeeStatus")
          .get()
          .timeout(const Duration(seconds: 10));

      if (snapshot.docs.isEmpty) {
        return {};
      }

      return {
        for (var doc in snapshot.docs)
          doc.id: (doc.data())
              .entries
              .map((entry) => FeeModel.fromFirebaseMap(entry.key, entry.value))
              .toList()
      };
    } catch (e) {
      throw Exception("Error fetching fee history with months: $e");
    }
  }
}
