import 'package:flutter/material.dart';
import 'widgets/tutorial_detail_shell.dart';
import 'package:app/services/tutorial_progress_service.dart';

class EmailPhishingPage extends StatelessWidget {
  const EmailPhishingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialDetailShell(
      title: 'Email & Phishing Awareness',
      onCta: () async {
        await TutorialProgressService.markCompleted('phishing');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marked "Email & Phishing Awareness" as complete')),
          );
          Navigator.pop(context);
        }
      },
      children: const [
        TTitle('Why it matters'),
        TSub('Phishing, spear-phishing, BEC, and “quishing” (QR phishing) are the top ways attackers steal credentials.'),

        TSection('Threats',
            '• Phishing/spear-phishing, business email compromise (BEC).\n'
                '• QR-phishing, attachment malware, invoice fraud.'),

        TSection('Learning goals',
            'Spot red flags, verify requests out-of-band, report safely.'),

        TSection('Red flags',
            'Urgency/scare tactics; prizes/refunds; mismatched display name vs domain; odd grammar; unexpected attachments; '
                'shortened/typo domains; payment/OTP requests.'),

        TSection('Safe actions',
            '• Hover/long-press to preview URL; check the real domain (no look-alikes/punycode).\n'
                '• Don’t open macros or unknown .exe/.js/.scr/.zip.\n'
                '• Verify money/credential requests via a known phone/portal.\n'
                '• Use the built-in “Report phishing” and delete.'),

        TSection('Advanced notes',
            'SPF/DKIM/DMARC protect the sending domain, not you — still verify.\n'
                'Quishing: open QR codes in a safe viewer; verify URL before login.\n'
                'Vishing/smishing: never share OTPs or reset links.'),

        TSection('Attachments',
            'Only open expected files from verified senders; prefer PDFs over Office with macros; when in doubt, open in online viewer/sandbox.'),

        TSection('If clicked',
            'Disconnect network (if malware likely), change password, enable/rotate MFA, report to IT/Sec immediately.'),

        TSection('Examples',
            '“CEO” asks for gift cards urgently → verify via phone.\n'
                '“Bank” says account locked; link goes to securrity-bank.com → report.'),

        TSection('Team/Policy metrics',
            'Time-to-report, reported-phish rate, click-through rate on simulations.'),
      ],
    );
  }
}
