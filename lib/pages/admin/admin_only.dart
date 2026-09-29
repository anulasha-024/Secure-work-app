import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<bool> _isAdmin() async {
  final u = FirebaseAuth.instance.currentUser;
  if (u == null) return false;
  final token = await u.getIdTokenResult(true);
  return token.claims?['role'] == 'admin';
}

class AdminOnly extends StatelessWidget {
  final Widget child;
  const AdminOnly({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isAdmin(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snap.data! ? child : const _Forbidden();
      },
    );
  }
}

class _Forbidden extends StatelessWidget {
  const _Forbidden();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Admin')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded, size: 54),
          const SizedBox(height: 12),
          const Text('You need admin access.'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text('Back'),
          ),
        ],
      ),
    ),
  );
}
