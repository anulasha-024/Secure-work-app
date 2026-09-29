import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <_Tile>[
      _Tile('Users', Icons.people_alt_rounded, '/admin/users'),
      _Tile('Policies', Icons.rule_folder_rounded, '/admin/policies'),
      _Tile('Tutorials', Icons.menu_book_rounded, '/admin/tutorials'),
      _Tile('Quizzes', Icons.quiz_rounded, '/admin/quizzes'),
      _Tile('Incidents', Icons.report_gmailerrorred_rounded, '/admin/incidents'),
      _Tile('Announcements', Icons.campaign_rounded, '/admin/announcements'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Console')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05),
        itemBuilder: (context, i) => _AdminCard(tile: tiles[i]),
      ),
    );
  }
}

class _Tile {
  final String title; final IconData icon; final String route;
  _Tile(this.title, this.icon, this.route);
}

class _AdminCard extends StatelessWidget {
  final _Tile tile;
  const _AdminCard({required this.tile});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, tile.route),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 12, offset: const Offset(0,6))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tile.icon, size: 40),
            const SizedBox(height: 12),
            Text(tile.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
