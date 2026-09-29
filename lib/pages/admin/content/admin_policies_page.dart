import 'package:flutter/material.dart';

class AdminPoliciesPage extends StatelessWidget {
  const AdminPoliciesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Policies (Admin)')),
      body: const Center(child: Text('TODO: CRUD policies with version & publish toggle')),
    );
  }
}
