import 'package:flutter/material.dart';

class AdminIncidentsPage extends StatelessWidget {
  const AdminIncidentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incidents (Admin)')),
      body: const Center(child: Text('TODO: triage, status, assignee, export')),
    );
  }
}
