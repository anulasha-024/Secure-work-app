import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PolicyAcceptanceService {
  static const _localPrefix = 'accepted_policy_ids_'; // namespaced by uid

  static String? _uid() => FirebaseAuth.instance.currentUser?.uid;

  static DocumentReference<Map<String, dynamic>>? _userDoc() {
    final uid = _uid();
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  /// Mark a policy as accepted (writes to Firestore + local cache)
  static Future<void> markAccepted(String policyId) async {
    final doc = _userDoc();
    final uid = _uid();
    if (doc == null || uid == null) return;

    // Firestore (authoritative): add/merge under policyAcks.<policyId> = server time
    await doc.set({
      'policyAcks': {
        policyId: FieldValue.serverTimestamp(),
      }
    }, SetOptions(merge: true));

    // Optional: local cache per uid (for quick reads / offline UI)
    final prefs = await SharedPreferences.getInstance();
    final key = '$_localPrefix$uid';
    final set = prefs.getStringList(key)?.toSet() ?? <String>{};
    set.add(policyId);
    await prefs.setStringList(key, set.toList());
  }

  /// Stream of accepted policy IDs (live updates)
  static Stream<Set<String>> acceptedIdsStream() {
    final doc = _userDoc();
    if (doc == null) return const Stream<Set<String>>.empty();
    return doc.snapshots().map((snap) {
      final data = snap.data();
      final map = (data?['policyAcks'] as Map<String, dynamic>?) ?? {};
      return map.keys.toSet();
    });
  }

  /// One-shot fetch of accepted IDs
  static Future<Set<String>> getAcceptedIds() async {
    final doc = _userDoc();
    if (doc == null) return <String>{};
    final snap = await doc.get();
    final map = (snap.data()?['policyAcks'] as Map<String, dynamic>?) ?? {};
    return map.keys.toSet();
  }

  /// Progress helper (0..1)
  static Future<double> progress({int totalPolicies = 6}) async {
    final ids = await getAcceptedIds();
    if (totalPolicies <= 0) return 0;
    final p = ids.length / totalPolicies;
    return p > 1 ? 1 : p;
  }

  /// Live progress (stream)
  static Stream<double> progressStream({int totalPolicies = 6}) {
    return acceptedIdsStream().map((ids) {
      if (totalPolicies <= 0) return 0.0;
      final p = ids.length / totalPolicies;
      return p > 1 ? 1 : p;
    });
  }

  /// (Optional) revoke an accept
  static Future<void> revoke(String policyId) async {
    final doc = _userDoc();
    final uid = _uid();
    if (doc == null || uid == null) return;
    await doc.update({'policyAcks.$policyId': FieldValue.delete()});

    final prefs = await SharedPreferences.getInstance();
    final key = '$_localPrefix$uid';
    final set = prefs.getStringList(key)?.toSet() ?? <String>{};
    set.remove(policyId);
    await prefs.setStringList(key, set.toList());
  }

  static Future isAccepted(String policyId) async {}
}
