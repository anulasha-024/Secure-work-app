import 'package:flutter/material.dart';
import 'widgets/policy_detail_shell.dart';

class ResponsibilitiesPage extends StatelessWidget {
  const ResponsibilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyDetailShell(
      policyId: 'responsibilities',
      title: 'Your Responsibilities',
      lastUpdated: '2025-09-01',
      clauses: const [
        _H('Access & Authentication'),
        _B('Use only your account. Do not share passwords/OTPs or unlocked devices. '
            'Enable MFA and sign out on shared devices.'),
        SizedBox(height: 12),
        _H('Data Handling'),
        _B('Treat content as Internal/Confidential unless labeled Public. '
            'Collect the minimum personal data needed. Avoid screenshots/exports or re-sharing outside authorized channels.'),
        SizedBox(height: 12),
        _H('Device & Network (BYOD included)'),
        _B('Keep OS/apps updated; use screen lock (PIN/biometric). Do not use rooted/jailbroken devices. '
            'Use trusted networks; avoid public Wi-Fi for sensitive actions unless using SLNSS-approved VPN.'),
        SizedBox(height: 12),
        _H('Content & Uploads'),
        _B('Upload only lawful, work-related content; redact unnecessary personal data; respect third-party IP; never upload malware.'),
        SizedBox(height: 12),
        _H('Training Conduct'),
        _B('Complete training/quizzes honestly; do not share answers or bypass timers; stay professional and respectful.'),
        SizedBox(height: 12),
        _H('Privacy & Monitoring'),
        _B('Activity logging is enabled for security/ops/training/compliance (see Purpose & Consent). Use means you consent per SLNSS policy and law.'),
        SizedBox(height: 48),
      ],
    );
  }
}

class _H extends StatelessWidget { final String t; const _H(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:16,fontWeight:FontWeight.w700)); }
class _B extends StatelessWidget { final String t; const _B(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:14,height:1.55)); }
