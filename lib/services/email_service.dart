import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();
  factory EmailService() => _instance;
  EmailService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send email notification on sign in
  Future<void> sendSignInEmail({
    required String userEmail,
    required String userName,
    required String userId,
  }) async {
    try {
      // Store email notification request in Firestore
      // This will be processed by a Cloud Function
      await _firestore.collection('email_notifications').add({
        'type': 'sign_in',
        'userEmail': userEmail,
        'userName': userName,
        'userId': userId,
        'subject': 'Welcome back to Facebook!',
        'body': '''
Hello $userName,

You have successfully signed in to your Facebook account.

If this wasn't you, please secure your account immediately.

Best regards,
Facebook Team
        ''',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Sign-in email notification queued for: $userEmail');
      }
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Send Sign-In Email Error',
        fatal: false,
      );
    }
  }

  // Send email notification on sign up
  Future<void> sendSignUpEmail({
    required String userEmail,
    required String userName,
    required String userId,
  }) async {
    try {
      // Store email notification request in Firestore
      // This will be processed by a Cloud Function
      await _firestore.collection('email_notifications').add({
        'type': 'sign_up',
        'userEmail': userEmail,
        'userName': userName,
        'userId': userId,
        'subject': 'Welcome to Facebook!',
        'body': '''
Hello $userName,

Welcome to Facebook! Your account has been created successfully.

We're excited to have you on board. Get started by completing your profile and connecting with friends.

Best regards,
Facebook Team
        ''',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Sign-up email notification queued for: $userEmail');
      }
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Send Sign-Up Email Error',
        fatal: false,
      );
    }
  }

  // Send email notification on sign out
  Future<void> sendSignOutEmail({
    required String userEmail,
    required String userName,
    required String userId,
  }) async {
    try {
      // Store email notification request in Firestore
      // This will be processed by a Cloud Function
      await _firestore.collection('email_notifications').add({
        'type': 'sign_out',
        'userEmail': userEmail,
        'userName': userName,
        'userId': userId,
        'subject': 'You signed out of Facebook',
        'body': '''
Hello $userName,

You have successfully signed out of your Facebook account.

If this wasn't you, please secure your account immediately by changing your password.

Best regards,
Facebook Team
        ''',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Sign-out email notification queued for: $userEmail');
      }
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Send Sign-Out Email Error',
        fatal: false,
      );
    }
  }
}

