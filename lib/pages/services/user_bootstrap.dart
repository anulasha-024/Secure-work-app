// lib/services/user_bootstrap.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> ensureUserDoc(User user) async {
  final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await FirebaseFirestore.instance.runTransaction((tx) async {
    final snap = await tx.get(ref);

    if (!snap.exists) {
      // First time: create WITHOUT 'role' (let admins set it later)
      tx.set(ref, {
        'uid': user.uid,
        'displayName': user.displayName ?? '',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        // init maps so UI chips work
        'tutorialsDone': <String, bool>{},
        'quizzesDone': <String, bool>{},
        'policyAcks': <String, bool>{},
      });
    } else {
      // Subsequent logins: merge non-destructive fields; DO NOT touch 'role'
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final toMerge = <String, dynamic>{
        if ((data['displayName'] ?? '').toString().isEmpty)
          'displayName': user.displayName ?? '',
        if ((data['email'] ?? '').toString().isEmpty)
          'email': user.email ?? '',
        if ((data['photoURL'] ?? '').toString().isEmpty)
          'photoURL': user.photoURL ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
        if (data['tutorialsDone'] == null) 'tutorialsDone': <String, bool>{},
        if (data['quizzesDone'] == null) 'quizzesDone': <String, bool>{},
        if (data['policyAcks'] == null) 'policyAcks': <String, bool>{},
      };
      if (toMerge.isNotEmpty) {
        tx.set(ref, toMerge, SetOptions(merge: true));
      }
    }
  });
}
