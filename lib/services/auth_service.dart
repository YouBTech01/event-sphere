import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Web: Use Firebase Auth signInWithPopup which natively handles Google OAuth on Web
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile: Trigger standard native Google Sign-In
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // User aborted the sign-in
          return null;
        }

        // Obtain the auth details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      final User? user = userCredential.user;
      if (user != null) {
        await _ensureUserInFirestore(user);
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _ensureUserInFirestore(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      // First-time users are created in Firestore
      final newUser = UserModel(
        uid: user.uid,
        fullName: user.displayName ?? (user.email?.split('@').first ?? 'User'),
        email: user.email ?? '',
        photoUrl: user.photoURL,
        joinedEventsCount: 0,
        themeMode: 'system',
        createdAt: DateTime.now(),
      );
      await docRef.set(newUser.toMap());
    } else {
      // Update basic profile fields if changed without overriding count or theme
      await docRef.set({
        'fullName':
            user.displayName ?? (doc.data()?['fullName'] ?? 'User'),
        'email': user.email ?? (doc.data()?['email'] ?? ''),
        'photoUrl': user.photoURL ?? doc.data()?['photoUrl'],
      }, SetOptions(merge: true));
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}
    await _auth.signOut();
  }
}
