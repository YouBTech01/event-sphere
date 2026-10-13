import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationModel {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final DateTime joinedAt;

  RegistrationModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.joinedAt,
  });

  factory RegistrationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime parseTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return RegistrationModel(
      userId: data['userId'] as String? ?? doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      joinedAt: parseTimestamp(data['joinedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}
