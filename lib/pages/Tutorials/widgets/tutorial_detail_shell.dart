import 'package:flutter/material.dart';

class TutorialDetailShell extends StatelessWidget {
  final String title;                // e.g., "Password Management"
  final List<Widget> children;       // your content blocks
  final String ctaText;              // e.g., "Complete Profile"
  final VoidCallback? onCta;         // pressed -> navigate/do something

  const TutorialDetailShell({
    super.key,
    required this.title,
    required this.children,
    this.ctaText = 'Complete Profile',
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(title),
        actions: const [
          // (Optional) overflow menu icon to match mock
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: children,
      ),
      bottomSheet: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: FilledButton(
            onPressed: onCta ?? () => Navigator.pushNamed(context, '/profile'),
            child: Text(ctaText),
          ),
        ),
      ),
    );
  }
}

// Small helpers to keep pages clean
class TTitle extends StatelessWidget {
  final String text; const TTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 6),
    child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
  );
}

class TSub extends StatelessWidget {
  final String text; const TSub(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(text, style: const TextStyle(fontSize: 14.5, height: 1.55)),
  );
}

class TSection extends StatelessWidget {
  final String title;
  final String body;
  const TSection(this.title, this.body, {super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [TTitle(title), TSub(body)],
  );
}

class InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  const InfoCard({super.key, required this.title, required this.body, this.icon = Icons.info_outline_rounded});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48, width: 48,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 24, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
