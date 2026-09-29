import 'package:flutter/material.dart';
import 'widgets/policy_detail_shell.dart';

class ProhibitedUsePage extends StatelessWidget {
  const ProhibitedUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyDetailShell(
      policyId: 'prohibited_use',
      title: 'Prohibited Use',
      lastUpdated: '2025-09-01',
      clauses: const [
        _H('Never use the app to'),
        _B('• Break laws or share unlawful content (e.g., pirated or criminal materials).\n'
            '• Post defamatory, obscene, hateful, or violent content; or infringe IP.\n'
            '• Hack, probe, scan, reverse engineer, bypass controls, disrupt services, spread malware, or exploit vulnerabilities.\n'
            '• Store SLNSS data in personal apps/unapproved locations or export without authorization.\n'
            '• Impersonate others, run phishing/social engineering.\n'
            '• Send spam/bulk messages or advertise without written approval.\n'
            '• Bully, harass, threaten, stalk, or promote discrimination.'),
        SizedBox(height: 12),
        _H('Quick examples'),
        _B('❌ Upload quiz dumps; ✅ complete training honestly (see “Your Responsibilities”).'),
        SizedBox(height: 12),
        _H('Consequences'),
        _B('Violations may lead to content removal, access restriction, HR/Legal actions, and reporting to authorities.'),
        SizedBox(height: 48),
      ],
    );
  }
}

class _H extends StatelessWidget { final String t; const _H(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:16,fontWeight:FontWeight.w700)); }
class _B extends StatelessWidget { final String t; const _B(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:14,height:1.55)); }
