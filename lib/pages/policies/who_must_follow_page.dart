import 'package:flutter/material.dart';
import 'widgets/policy_detail_shell.dart';

class WhoMustFollowPage extends StatelessWidget {
  const WhoMustFollowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyDetailShell(
      policyId: 'who_follow',
      title: 'Who Must Follow',
      lastUpdated: '2025-09-01',
      clauses: const [
        _H('Applicability'),
        _B('• Employees, volunteers, interns, and trainees.\n'
            '• Managers, admins, and designated content owners.\n'
            '• Contractors, partners, third parties with access; approved guests.'),
        SizedBox(height: 12),
        _H('Responsibilities by role'),
        _B('• End users: follow AUP; protect credentials; report issues promptly.\n'
            '• Managers: model good behavior; ensure team completion of training.\n'
            '• Admins: apply least-privilege, maintain logs, respond to incidents.'),
        SizedBox(height: 12),
        _H('Important note'),
        _B('App access is a privilege; SLNSS may revoke/restrict it for violations or risk mitigation.'),
        SizedBox(height: 48),
      ],
    );
  }
}

class _H extends StatelessWidget { final String t; const _H(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:16,fontWeight:FontWeight.w700)); }
class _B extends StatelessWidget { final String t; const _B(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:14,height:1.55)); }
