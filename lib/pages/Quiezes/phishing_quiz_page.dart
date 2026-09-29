import 'package:flutter/material.dart';
import 'widgets/quiz_shell.dart';
import 'package:app/services/quiz_progress_service.dart';

class PhishingQuizPage extends StatelessWidget {
  const PhishingQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    const qs = [
      QuizQuestion(
        'Which detail best reveals a phishing email?',
        [
          'Sent late at night',
          'Nice logo and footer',
          'Mismatched display name vs real domain',
          'Uses your name',
          'Short message'
        ],
        2,
      ),
      QuizQuestion(
        'Before clicking any email link, you should:',
        [
          'Reply and ask if it’s safe',
          'Open in Incognito',
          'Hover/long-press to preview the real URL',
          'Forward to a friend',
          'Click quickly to avoid timeout'
        ],
        2,
      ),
      QuizQuestion(
        'Which attachment is riskiest from an unknown sender?',
        [
          'Plain text .txt',
          '.zip archive or .exe/.js/.scr',
          'Expected PDF',
          'Image .png',
          'Calendar .ics'
        ],
        1,
      ),
      QuizQuestion(
        'A hallmark of Business Email Compromise (BEC) is:',
        [
          'Free gift offers',
          'Newsletter opt-in',
          'Urgent request to change payment/bank details “from the CEO”',
          'Weather update',
          'Meeting reminder'
        ],
        2,
      ),
      QuizQuestion(
        'You entered credentials on a fake page. What next?',
        [
          'Close the tab and ignore it',
          'Tell a coworker only',
          'Change password, revoke sessions, enable/rotate MFA, and report',
          'Delete browser history only',
          'Call the attacker'
        ],
        2,
      ),
    ];

    return QuizShell(
      title: 'Email & Phishing Awareness',
      quizId: 'phishing',
      questions: qs,
      onCompletedFullScore: () => QuizProgressService.markCompleted('phishing'),
    );
  }
}
