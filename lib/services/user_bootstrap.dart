// lib/services/user_bootstrap.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> ensureUserDoc(
    User user, {
      String role = 'user',        // <<< NEW: pass the chosen role (defaults to 'user')
      String? displayName,
    }) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await doc.set({
    'displayName': (displayName ?? user.displayName ?? ''),  // ← use passed name
    'email': user.email ?? '',
    'role': 'user',              // default
    'tutorialsProgress': 0.0,    // 0.0 .. 1.0
    'quizzesProgress': 0.0,
    'policiesProgress': 0.0,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));   // keeps existing values if doc already exists
}// TODO Implement this library.