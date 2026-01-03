import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/notification_service.dart';
import '../services/email_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();
  final EmailService _emailService = EmailService();

  // Observable user state
  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  // Observable loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _user.value = user;
      if (user != null) {
        // Save FCM token when user signs in
        _saveUserData(user);
      }
    });
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      
      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        _isLoading.value = false;
        return false;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if user exists before signing in
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      final User? user = userCredential.user;

      if (user != null) {
        // Save user data to Firestore
        await _saveUserDataToFirestore(user, googleUser);
        
        // Save FCM token
        await _notificationService.saveFCMTokenToUser(user.uid);
        
        // Send notifications
        final String userName = user.displayName ?? user.email?.split('@').first ?? 'User';
        final String userEmail = user.email ?? '';
        
        if (isNewUser) {
          // Send local notification
          await _notificationService.notifySignUp(userName);
          // Send email notification
          await _emailService.sendSignUpEmail(
            userEmail: userEmail,
            userName: userName,
            userId: user.uid,
          );
        } else {
          // Send local notification
          await _notificationService.notifySignIn(userName);
          // Send email notification
          await _emailService.sendSignInEmail(
            userEmail: userEmail,
            userName: userName,
            userId: user.uid,
          );
        }
      }

      _isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      _isLoading.value = false;
      // Log error to Crashlytics
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Google Sign-In Error',
        fatal: false,
      );
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Get user info before signing out
        final String userName = currentUser.displayName ?? currentUser.email?.split('@').first ?? 'User';
        final String userEmail = currentUser.email ?? '';
        final String userId = currentUser.uid;
        
        // Send email notification before signing out
        await _emailService.sendSignOutEmail(
          userEmail: userEmail,
          userName: userName,
          userId: userId,
        );
        
        // Delete FCM token from user document
        await _notificationService.deleteFCMTokenFromUser(currentUser.uid);
      }
      
      await _googleSignIn.signOut();
      await _auth.signOut();
      _isLoading.value = false;
    } catch (e, stackTrace) {
      _isLoading.value = false;
      // Log error to Crashlytics
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Sign Out Error',
        fatal: false,
      );
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserDataToFirestore(User user, GoogleSignInAccount googleUser) async {
    try {
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? googleUser.displayName,
        'photoURL': user.photoURL ?? googleUser.photoUrl,
        'provider': 'google.com',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(user.uid).set(
        userData,
        SetOptions(merge: true),
      );

      // Update last login timestamp
      await _firestore.collection('users').doc(user.uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Save User Data Error',
        fatal: false,
      );
    }
  }

  // Save user data (called from auth state changes)
  Future<void> _saveUserData(User user) async {
    try {
      await _notificationService.saveFCMTokenToUser(user.uid);
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Save User Data Error',
        fatal: false,
      );
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _user.value != null;
}

