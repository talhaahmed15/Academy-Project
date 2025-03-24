import 'package:ahmed_academy/Models/fee_model.dart';
import 'package:flutter/material.dart';

class FeeDetailCard extends StatelessWidget {
  final FeeModel object;

  const FeeDetailCard({
    super.key,
    required this.object,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Name:", object.studentName),
          _buildDetailRow("Class:", object.classNo),
          _buildDetailRow("Amount:", "Rs. ${object.amount}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Fees Paid:",
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                object.isFeesPaid ? "Paid" : "Unpaid",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.bold,
                  color: object.isFeesPaid == false ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            // fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'OpenSans',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
