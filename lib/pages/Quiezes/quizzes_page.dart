import 'package:flutter/material.dart';

class QuizzesPage extends StatelessWidget {
  const QuizzesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_QuizItem>[
      _QuizItem(
        title: 'Password Management',
        asset: 'images/New-pw.png',
        dark: true,
        onTap: () => Navigator.pushNamed(context, '/quiz/passwords'),
      ),
      _QuizItem(
        title: 'Email & Phishing Awareness',
        asset: 'images/policies_icon.png', // swap to a phishing image if you add one
        dark: false,
        onTap: () => Navigator.pushNamed(context, '/quiz/phishing'),
      ),
      _QuizItem(
        title: 'Safe Internet Browsing',
        asset: 'images/tutorials_icon.png',
        dark: true,
        onTap: () => Navigator.pushNamed(context, '/quiz/browsing'),
      ),
      _QuizItem(
        title: 'Device Security',
        asset: 'images/security_icon.png',
        dark: false,
        onTap: () => Navigator.pushNamed(context, '/quiz/device'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Quizzes', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) => _QuizCard(item: items[i]),
      ),
    );
  }
}

class _QuizItem {
  final String title;
  final String asset;     // e.g. 'images/New-pw.png'
  final bool dark;        // black card or white outlined card
  final VoidCallback onTap;

  const _QuizItem({
    required this.title,
    required this.asset,
    required this.dark,
    required this.onTap,
  });
}

class _QuizCard extends StatelessWidget {
  final _QuizItem item;
  const _QuizCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bg = item.dark ? Colors.black : Colors.white;
    final fg = item.dark ? Colors.white : Colors.black87;
    final border = item.dark ? null : Border.all(color: const Color(0xFFDDDDDD), width: 1.2);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 88,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: fg,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                height: 68,
                width: 96,
                child: Image.asset(item.asset, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
