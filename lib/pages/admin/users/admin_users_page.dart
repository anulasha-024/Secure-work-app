import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});
  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  String _query = '';

  Future<void> _setRole(String uid, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(uid)
        .set({'role': role}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance
        .collection('users')
        .orderBy('displayName', descending: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search name or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: users.snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs.where((d) {
                  if (_query.isEmpty) return true;
                  final m = d.data();
                  final name = (m['displayName'] ?? '').toString().toLowerCase();
                  final email = (m['email'] ?? '').toString().toLowerCase();
                  return name.contains(_query) || email.contains(_query);
                }).toList();

                if (docs.isEmpty) return const Center(child: Text('No users found.'));

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final d = docs[i];
                    final m = d.data();
                    final uid = d.id;
                    final name = (m['displayName'] ?? '—') as String;
                    final email = (m['email'] ?? '—') as String;
                    final role = (m['role'] ?? 'user') as String;
                    final tDone = ((m['tutorialsDone'] ?? {}) as Map).length;
                    final qDone = ((m['quizzesDone'] ?? {}) as Map).length;
                    final pDone = ((m['policyAcks'] ?? {}) as Map).length;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 8,
                          offset: const Offset(0,4),
                        )],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(email),
                            const SizedBox(height: 6),
                            Row(children: [
                              _Chip('Role: $role'),
                              const SizedBox(width: 6),
                              _Chip('Tut: $tDone/4'),
                              const SizedBox(width: 6),
                              _Chip('Quiz: $qDone/4'),
                              const SizedBox(width: 6),
                              _Chip('Policy: $pDone/6'),
                            ]),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) => _handleAction(v, uid, role, name),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: role == 'admin' ? 'make_user' : 'make_admin',
                              child: Text(role == 'admin' ? 'Demote to user' : 'Promote to admin'),
                            ),
                            const PopupMenuItem(value: 'reset', child: Text('Password reset (console)')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(String action, String uid, String role, String name) async {
    try {
      if (action == 'make_admin' || action == 'make_user') {
        final to = action == 'make_admin' ? 'admin' : 'user';
        await _setRole(uid, to);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated $name → $to')),
        );
      } else if (action == 'reset') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Send reset email from Firebase Console → Authentication.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action failed: $e')),
      );
    }
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF3D34B4))),
    );
  }
}
