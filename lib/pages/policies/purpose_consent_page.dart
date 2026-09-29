import 'package:flutter/material.dart';
import 'widgets/policy_detail_shell.dart';

class PurposeConsentPage extends StatelessWidget {
  const PurposeConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyDetailShell(
      policyId: 'purpose_consent',
      title: 'Purpose & Consent',
      lastUpdated: '2025-09-01',
      clauses: const [
        _H1('What this app is for'),
        _B('• Train SLNSS staff on security awareness and acceptable use.\n'
            '• Collect policy acknowledgments and maintain audit trails.\n'
            '• Provide tutorials, quizzes, and official notices.\n'
            '• Enable safe incident reporting with structured fields.'),
        SizedBox(height: 12),
        _H1('Legal basis & consent'),
        _B('By installing/using SecureWork you accept this AUP, all SLNSS policies, '
            'and applicable law (incl. Sri Lanka PDPA No. 9 of 2022). '
            'You agree that use of the app may be logged for security, operations, training, and compliance.'),
        SizedBox(height: 12),
        _H1('Why it matters'),
        _B('Clear behavior rules protect people, systems, and data; they reduce risk of data breaches, misuse, and reputational harm.'),
        SizedBox(height: 12),
        _H1('What we log (examples)'),
        _B('Sign-ins, device/OS, IP, page views, quiz attempts/scores, policy acknowledgments, '
            'incident submissions, admin actions, and crash diagnostics (e.g., Firebase).'),
        SizedBox(height: 12),
        _H1('Data minimisation & retention'),
        _B('We collect only what is needed for the above purposes and retain data per SLNSS policy and legal requirements.'),
        SizedBox(height: 12),
        _H1('Your choices'),
        _B('If you do not agree, do not use the app or contact SLNSS for alternatives. '
            'Some services may be unavailable without acceptance.'),
        SizedBox(height: 24),
        _H1('Definitions'),
        _B('“AUP” means Acceptable Use Policy. “PDPA” means Personal Data Protection Act, No. 9 of 2022 (Sri Lanka).'),
        SizedBox(height: 48),
      ],
    );
  }
}

class _H1 extends StatelessWidget {
  final String t; const _H1(this.t, {super.key});
  @override Widget build(BuildContext c) =>
      Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));
}
class _B extends StatelessWidget {
  final String t; const _B(this.t, {super.key});
  @override Widget build(BuildContext c) =>
      Text(t, style: const TextStyle(fontSize: 14, height: 1.55));
}
