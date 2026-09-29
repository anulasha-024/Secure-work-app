import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TutorialProgressService {
  static String? _uid() => FirebaseAuth.instance.currentUser?.uid;

  static DocumentReference<Map<String, dynamic>>? _userDoc() {
    final uid = _uid();
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  /// Mark a tutorial as completed. `tutorialId` one of:
  /// passwords | phishing | browsing | device  (use the same ids in routes)
  static Future<void> markCompleted(String tutorialId) async {
    final doc = _userDoc();
    if (doc == null) return;
    await doc.set({
      'tutorialsDone': { tutorialId: FieldValue.serverTimestamp() }
    }, SetOptions(merge: true));
  }

  /// Remove a completion (handy for testing)
  static Future<void> revoke(String tutorialId) async {
    final doc = _userDoc();
    if (doc == null) return;
    await doc.update({ 'tutorialsDone.$tutorialId': FieldValue.delete() });
  }

  /// Stream of completed tutorial ids
  static Stream<Set<String>> completedIdsStream() {
    final doc = _userDoc();
    if (doc == null) return const Stream<Set<String>>.empty();
    return doc.snapshots().map((s) {
      final map = (s.data()?['tutorialsDone'] as Map<String, dynamic>?) ?? {};
      return map.keys.toSet();
    });
  }

  /// One-shot
  static Future<Set<String>> getCompletedIds() async {
    final doc = _userDoc();
    if (doc == null) return <String>{};
    final s = await doc.get();
    final map = (s.data()?['tutorialsDone'] as Map<String, dynamic>?) ?? {};
    return map.keys.toSet();
  }

  /// Progress 0..1 (default 4 tutorials → 25% each)
  static Future<double> progress({int totalTutorials = 4}) async {
    final ids = await getCompletedIds();
    if (totalTutorials <= 0) return 0;
    final p = ids.length / totalTutorials;
    return p > 1 ? 1 : p;
  }

  /// Live progress stream
  static Stream<double> progressStream({int totalTutorials = 4}) {
    return completedIdsStream().map((ids) {
      if (totalTutorials <= 0) return 0.0;
      final p = ids.length / totalTutorials;
      return p > 1 ? 1 : p;
    });
  }
}
