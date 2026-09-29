import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizProgressService {
  static String? _uid() => FirebaseAuth.instance.currentUser?.uid;
  static DocumentReference<Map<String, dynamic>>? _doc() {
    final uid = _uid();
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  /// Mark quiz as completed. Use ids: passwords | phishing | browsing | device
  static Future<void> markCompleted(String quizId) async {
    final d = _doc();
    if (d == null) return;
    await d.set({
      'quizzesDone': { quizId: FieldValue.serverTimestamp() }
    }, SetOptions(merge: true));
  }

  static Future<void> revoke(String quizId) async {
    final d = _doc();
    if (d == null) return;
    await d.update({'quizzesDone.$quizId': FieldValue.delete()});
  }

  static Stream<Set<String>> completedIdsStream() {
    final d = _doc();
    if (d == null) return const Stream<Set<String>>.empty();
    return d.snapshots().map((s) {
      final map = (s.data()?['quizzesDone'] as Map<String, dynamic>?) ?? {};
      return map.keys.toSet();
    });
  }

  static Stream<double> progressStream({int total = 4}) =>
      completedIdsStream().map((ids) {
        final p = total <= 0 ? 0.0 : ids.length / total;
        return p > 1 ? 1 : p;
      });
}
