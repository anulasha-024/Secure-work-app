import 'package:flutter/material.dart';
import 'package:app/services/tutorial_progress_service.dart'; // NEW: to read completed tutorials

/// Centralize route names to avoid typos
class TutorialRoutes {
  static const password = '/tutorial/passwords';
  static const phishing = '/tutorial/phishing';
  static const browsing = '/tutorial/browsing';
  static const device   = '/tutorial/device';
}

class TutorialsPage extends StatelessWidget {
  const TutorialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use your existing images from the /images folder (root level)
    final items = <_TutorialItem>[
      _TutorialItem(
        id: 'passwords',
        title: 'Password Management',
        asset: 'images/New-pw.png',
        dark: true,
        onTap: () => Navigator.pushNamed(context, TutorialRoutes.password),
      ),
      _TutorialItem(
        id: 'phishing',
        title: 'Email & Phishing Awareness',
        asset: 'images/policies_icon.png', // swap to a phishing image if you add one
        dark: false,
        onTap: () => Navigator.pushNamed(context, TutorialRoutes.phishing),
      ),
      _TutorialItem(
        id: 'browsing',
        title: 'Safe Internet Browsing',
        asset: 'images/tutorials_icon.png',
        dark: true,
        onTap: () => Navigator.pushNamed(context, TutorialRoutes.browsing),
      ),
      _TutorialItem(
        id: 'device',
        title: 'Device Security',
        asset: 'images/security_icon.png',
        dark: false,
        onTap: () => Navigator.pushNamed(context, TutorialRoutes.device),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Tutorials', style: TextStyle(fontWeight: FontWeight.w600)),
      ),

      // NEW: live completion state (per user)
      body: StreamBuilder<Set<String>>(
        stream: TutorialProgressService.completedIdsStream(),
        builder: (context, snap) {
          final completed = snap.data ?? const <String>{};

          return SafeArea(
            bottom: true,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final item = items[i];
                final isDone = completed.contains(item.id);
                return _TutorialCard(item: item, isDone: isDone);
              },
            ),
          );
        },
      ),
    );
  }
}

class _TutorialItem {
  final String id;      // NEW: 'passwords' | 'phishing' | 'browsing' | 'device'
  final String title;
  final String asset;   // e.g. 'images/New-pw.png'
  final bool dark;      // black card vs white outlined card
  final VoidCallback onTap;

  const _TutorialItem({
    required this.id,
    required this.title,
    required this.asset,
    required this.dark,
    required this.onTap,
  });
}

class _TutorialCard extends StatelessWidget {
  final _TutorialItem item;
  final bool isDone; // NEW
  const _TutorialCard({required this.item, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final bg = item.dark ? Colors.black : Colors.white;
    final fg = item.dark ? Colors.white : Colors.black87;
    final border = item.dark ? null : Border.all(color: const Color(0xFFDDDDDD), width: 1.2);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 96,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fg,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // NEW: little completed badge when done
                  if (isDone)
                    Row(
                      children: [
                        Icon(Icons.check_circle_rounded, size: 16, color: item.dark ? Colors.greenAccent : const Color(0xFF20BF55)),
                        const SizedBox(width: 6),
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: item.dark ? Colors.greenAccent : const Color(0xFF20BF55),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  Opacity(
                    opacity: isDone ? 0.85 : 1, // subtle cue if done
                    child: SizedBox(
                      height: 70,
                      width: 96,
                      child: Image.asset(
                        item.asset, // <-- uses /images/...
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.chevron_right_rounded, color: fg),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
