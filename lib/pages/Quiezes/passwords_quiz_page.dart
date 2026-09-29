import 'package:flutter/material.dart';
import 'widgets/quiz_shell.dart';
import 'package:app/services/quiz_progress_service.dart';

class PasswordsQuizPage extends StatelessWidget {
  const PasswordsQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    const qs = [
      QuizQuestion(
        'Which approach creates the strongest password for most sites?',
        [
          '8 characters with numbers',
          'Your name + birth year',
          '14–20 character passphrase of 4+ random words',
          '“Qwerty123!”',
          'Same password with different symbols'
        ],
        2,
      ),
      QuizQuestion(
        'What is the safest place to store recovery codes?',
        [
          'Screenshot in your photo gallery',
          'A chat with yourself',
          'Secure note/printed copy stored separately',
          'Sticky note on your monitor',
          'Email subject line'
        ],
        2,
      ),
      QuizQuestion(
        'Which MFA method should you prefer?',
        [
          'Email codes',
          'Security questions',
          'Authenticator app or hardware security key',
          'SMS codes',
          'No MFA if password is long'
        ],
        2,
      ),
      QuizQuestion(
        'After a breach notice includes your email, what should you do first?',
        [
          'Post on social media',
          'Change password and sign out other sessions',
          'Delete the account immediately',
          'Wait to see if anything happens',
          'Forward the email to friends'
        ],
        1,
      ),
      QuizQuestion(
        'What is the biggest risk of reusing one password across services?',
        [
          'You will forget it',
          'You must type more',
          'One breach can unlock many accounts',
          'Device slows down',
          'More spam emails'
        ],
        2,
      ),
    ];

    return QuizShell(
      title: 'Password Management',
      quizId: 'passwords',
      questions: qs,
      onCompletedFullScore: () => QuizProgressService.markCompleted('passwords'),
    );
  }
}
