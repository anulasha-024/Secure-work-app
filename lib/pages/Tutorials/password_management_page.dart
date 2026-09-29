import 'package:flutter/material.dart';
import 'widgets/tutorial_detail_shell.dart';
import 'package:app/services/tutorial_progress_service.dart';

class PasswordManagementPage extends StatelessWidget {
  const PasswordManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialDetailShell(
      title: 'Password Management',
      onCta: () async {
        await TutorialProgressService.markCompleted('passwords');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marked "Password Management" as complete')),
          );
          Navigator.pop(context);
        }
      },
      children: const [
        TTitle('Password Management system'),
        TSub('Learn how to store, organize, and protect your passwords safely'),

        TSection('Why it matters (threats)',
            '• Password reuse → one breach unlocks many accounts.\n'
                '• Guessing/credential stuffing/brute force; phishing of reset links.\n'
                '• Shoulder surfing; storing plaintext in notes/screenshots.'),

        TSection('Learning goals',
            '• Build 14–20 character passphrases, unique per site.\n'
                '• Use a password manager and MFA; store recovery codes safely.'),

        TSection('Key terms',
            '• Passphrase: long, memorable sentence/word string.\n'
                '• Password manager (PM): encrypted vault with autofill; protected by master passphrase.\n'
                '• MFA factors: something you know/have/are.\n'
                '• Recovery codes: one-time backup codes when you lose MFA device.'),

        TSection('Do / Don’t',
            '✅ Use ≥14 chars; 4+ random words + separators.\n'
                '✅ Different passwords for every service.\n'
                '✅ Prefer authenticator app / security key over SMS.\n'
                '✅ Save recovery codes in a secure note/printed copy kept separately.\n'
                '❌ Don’t reuse/share; don’t store in chat/notes/gallery.'),

        TSection('How-to (generic)',
            '• Create a master passphrase: 4–6 random words + numbers/symbols.\n'
                '• Install a PM (company-approved if applicable). Enable autofill.\n'
                '• Replace weak/reused passwords; turn on MFA for email/cloud/social/banking.\n'
                '• Download/print recovery codes; store separately.'),

        TSection('Platform tips',
            '• Android/iOS: Settings → Passwords/Autofill → set your PM.\n'
                '• Windows/macOS: install the PM app + browser extension.'),

        TSection('If compromised',
            'Change password → revoke sessions → enable/rotate MFA → check account activity → update other accounts if reused.'),

        TSection('Team/Policy metrics',
            '% unique passwords; average length; MFA coverage on critical apps.'),

        TTitle('Types of Password Managers'),
        InfoCard(
          title: 'Cloud-based Managers',
          body: 'Store encrypted passwords online and sync across devices.',
          icon: Icons.cloud_outlined,
        ),
        InfoCard(
          title: 'Local/Offline Managers',
          body: 'Keep your vault only on your device for more control.',
          icon: Icons.lock_outline_rounded,
        ),
        InfoCard(
          title: 'Browser-based Managers',
          body: 'Built into browsers; convenient but weaker if the browser is compromised.',
          icon: Icons.web_asset_outlined,
        ),
      ],
    );
  }
}
