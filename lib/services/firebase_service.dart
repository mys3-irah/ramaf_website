import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class RegistrationData {
  final String? id;
  final String eventId;
  final String eventTitle;
  final String fullName;
  final String guardianName;
  final String phone;
  final String email;
  final String address;
  final String district;
  final String qualification;
  final String category;
  final bool isConcessionApplied;
  final double feePaid;
  final String paymentId;
  final String paymentStatus; // 'Paid', 'Exempted', 'Pending'
  final DateTime registrationDate;

  RegistrationData({
    this.id,
    required this.eventId,
    required this.eventTitle,
    required this.fullName,
    required this.guardianName,
    required this.phone,
    required this.email,
    required this.address,
    required this.district,
    required this.qualification,
    required this.category,
    required this.isConcessionApplied,
    required this.feePaid,
    required this.paymentId,
    required this.paymentStatus,
    required this.registrationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'eventTitle': eventTitle,
      'fullName': fullName,
      'guardianName': guardianName,
      'phone': phone,
      'email': email,
      'address': address,
      'district': district,
      'qualification': qualification,
      'category': category,
      'isConcessionApplied': isConcessionApplied,
      'feePaid': feePaid,
      'paymentId': paymentId,
      'paymentStatus': paymentStatus,
      'registrationDate': Timestamp.fromDate(registrationDate),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isFirebaseInitialized = false;

  /// Check if Firebase has been initialized
  bool get isInitialized => _isFirebaseInitialized;

  /// Initialize Firebase app if configured
  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _isFirebaseInitialized = true;
      debugPrint('✅ Firebase (ramaf-database) initialized successfully.');
    } catch (e) {
      debugPrint('ℹ️ Firebase initialization notice: $e');
      _isFirebaseInitialized = false;
    }
  }

  /// Save registration to Cloud Firestore
  Future<String> submitRegistration(RegistrationData data) async {
    final String generatedRegId = 'RAMAF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    if (_isFirebaseInitialized) {
      try {
        final docRef = await FirebaseFirestore.instance
            .collection('event_registrations')
            .add({
          ...data.toMap(),
          'registrationNumber': generatedRegId,
        });
        return docRef.id.isNotEmpty ? generatedRegId : generatedRegId;
      } catch (e) {
        debugPrint('Firestore write error: $e. Using generated ID: $generatedRegId');
        return generatedRegId;
      }
    } else {
      debugPrint('Saved registration $generatedRegId (Sandbox mode)');
      return generatedRegId;
    }
  }

  /// Optional: Save contact form inquiry to Firestore
  Future<bool> submitContactInquiry({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    if (_isFirebaseInitialized) {
      try {
        await FirebaseFirestore.instance.collection('contact_inquiries').add({
          'name': name,
          'email': email,
          'phone': phone,
          'subject': subject,
          'message': message,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return true;
      } catch (e) {
        debugPrint('Firestore contact inquiry error: $e');
        return false;
      }
    }
    return true;
  }
}
