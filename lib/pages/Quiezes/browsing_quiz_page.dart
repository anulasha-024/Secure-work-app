import 'package:flutter/material.dart';
import 'widgets/quiz_shell.dart';
import 'package:app/services/quiz_progress_service.dart';

class BrowsingQuizPage extends StatelessWidget {
  const BrowsingQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    const qs = [
      QuizQuestion(
        'On public Wi-Fi, what is the safest setup for sensitive logins?',
        [
          'HTTP sites only',
          'Captive portal is enough',
          'Use HTTPS and a trusted VPN',
          'Turn off the firewall',
          'Share hotspot with strangers'
        ],
        2,
      ),
      QuizQuestion(
        'A pop-up says “Update your browser now—download here.” You should:',
        [
          'Download from the pop-up',
          'Ignore all updates',
          'Ask friends',
          'Close it and update from the browser’s official settings',
          'Disable pop-ups forever'
        ],
        3,
      ),
      QuizQuestion(
        'Best practice for extensions?',
        [
          'Install many for features',
          'Disable updates',
          'Keep few, reputable extensions; remove unused; review permissions',
          'Install from any website',
          'Use betas only'
        ],
        2,
      ),
      QuizQuestion(
        'What does HTTPS primarily provide?',
        [
          'Virus scanning of files',
          'Total trust in site owner',
          'Full anonymity',
          'Encryption in transit + certificate validation',
          'Faster downloads'
        ],
        3,
      ),
      QuizQuestion(
        'Browser shows a certificate/deceptive-site warning. Do what?',
        [
          'Leave; do not bypass the warning',
          'Add exception and continue',
          'Turn off HTTPS-only mode',
          'Disable antivirus',
          'Refresh repeatedly'
        ],
        0,
      ),
    ];

    return QuizShell(
      title: 'Safe Internet Browsing',
      quizId: 'browsing',
      questions: qs,
      onCompletedFullScore: () => QuizProgressService.markCompleted('browsing'),
    );
  }
}
