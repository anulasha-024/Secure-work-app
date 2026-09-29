import 'package:flutter/material.dart';
import 'widgets/quiz_shell.dart';
import 'package:app/services/quiz_progress_service.dart';

class DeviceQuizPage extends StatelessWidget {
  const DeviceQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    const qs = [
      QuizQuestion(
        'Best daily device lock setup?',
        [
          '4-digit PIN only',
          'Swipe to unlock',
          'Strong PIN/passcode + biometrics + short auto-lock',
          'Pattern lock only',
          'No lock at home'
        ],
        2,
      ),
      QuizQuestion(
        'Which ensures data remains protected if the device is stolen?',
        [
          'Airplane mode',
          'Background picture',
          'Full-disk encryption (BitLocker/FileVault or mobile default)',
          'Silent mode',
          'High screen brightness'
        ],
        2,
      ),
      QuizQuestion(
        'Safest source for apps/software?',
        [
          'Random download sites',
          'Email attachments',
          'Official stores/vendors or company portal',
          'Torrent sites',
          'Social media links'
        ],
        2,
      ),
      QuizQuestion(
        'Prevent data loss from failure/theft?',
        [
          'Keep everything on Desktop',
          'Enable encrypted backups and test restores',
          'Use larger Recycle Bin',
          'Rename files weekly',
          'Rely on browser history'
        ],
        1,
      ),
      QuizQuestion(
        'Lost phone you can’t recover. Correct sequence?',
        [
          'Buy a new phone first',
          'Wait 24 hours',
          'Try locate/ring → remote-lock & wipe → change passwords & revoke sessions → notify org/carrier → rotate MFA',
          'Post IMEI online',
          'Only change the wallpaper'
        ],
        2,
      ),
    ];

    return QuizShell(
      title: 'Device Security',
      quizId: 'device',
      questions: qs,
      onCompletedFullScore: () => QuizProgressService.markCompleted('device'),
    );
  }
}
