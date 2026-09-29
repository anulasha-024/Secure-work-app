import 'package:flutter/material.dart';
import 'widgets/tutorial_detail_shell.dart';
import 'package:app/services/tutorial_progress_service.dart';

class SafeBrowsingPage extends StatelessWidget {
  const SafeBrowsingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialDetailShell(
      title: 'Safe Internet Browsing',
      onCta: () async {
        await TutorialProgressService.markCompleted('browsing');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marked "Safe Internet Browsing" as complete')),
          );
          Navigator.pop(context);
        }
      },
      children: const [
        TTitle('Threats'),
        TSub('Drive-by downloads, malicious extensions, typosquatting, session hijacking on open Wi-Fi, malvertising, fake update popups.'),

        TSection('Learning goals',
            'Use secure connections, minimal permissions, and trusted sources.'),

        TSection('Core practices',
            '• Use HTTPS for logins (lock icon; avoid “Not secure”).\n'
                '• Public Wi-Fi: avoid sensitive logins; use trusted VPN; captive portals aren’t secure login pages.\n'
                '• Extensions: few and audited; remove unused; check vendor/reviews/permissions.\n'
                '• Updates: browser and extensions auto-update ON.\n'
                '• Downloads: official stores/vendors; verify checksum/signature if provided.\n'
                '• Permissions: deny camera/mic/location unless essential; review regularly.\n'
                '• Privacy: separate browser profiles (work/personal); clear site data on shared devices; consider blocking third-party cookies.'),

        TSection('Advanced',
            'DNS over HTTPS/secure DNS; passwordless (passkeys) where available; beware “free movie” sites and fake codec/Flash prompts.'),

        TSection('If a warning appears',
            '• Certificate error / deceptive site → do not bypass; leave.\n'
                '• “Your browser is out of date — download here” → close tab; update from official settings.'),

        TSection('Team/Policy metrics',
            'Extensions per user, % HTTPS usage, update latency, VPN usage on public networks.'),
      ],
    );
  }
}
