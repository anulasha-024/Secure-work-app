import 'package:flutter/material.dart';
import 'widgets/policy_detail_shell.dart';

class ReportingEnforcementPage extends StatelessWidget {
  const ReportingEnforcementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyDetailShell(
      policyId: 'reporting_enforcement',
      title: 'Reporting & Enforcement',
      lastUpdated: '2025-09-01',
      clauses: const [
        _H('How to report'),
        _B('• In-App: Incident Reporting module; submit facts and safe evidence. Don’t run your own investigation.\n'
            '• If the app is down: use SLNSS website or designated email/phone.\n'
            '• Urgent (active threats/safety risks/major exposure): alert your manager and SLNSS security contact immediately by the fastest channel.'),
        SizedBox(height: 12),
        _H('What SLNSS can do'),
        _B('Monitor activity for compliance, remove/block content, warn users, suspend/restrict/terminate access (immediately if needed), '
            'require remedial training/manager review, escalate to HR/Legal/authorities.'),
        SizedBox(height: 12),
        _H('Fairness'),
        _B('Decisions consider severity, intent, impact, and prior history. You may be asked for additional context.'),
        SizedBox(height: 48),
      ],
    );
  }
}

class _H extends StatelessWidget { final String t; const _H(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:16,fontWeight:FontWeight.w700)); }
class _B extends StatelessWidget { final String t; const _B(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:14,height:1.55)); }
