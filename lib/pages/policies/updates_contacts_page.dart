import 'package:flutter/material.dart';
import 'widgets/policy_detail_shell.dart';

class UpdatesContactsPage extends StatelessWidget {
  const UpdatesContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PolicyDetailShell(
      policyId: 'updates_contacts',
      title: 'Updates & Contacts',
      lastUpdated: '2025-09-01',
      clauses: const [
        _H('Policy updates'),
        _B('This AUP may be updated for new features, risks, or laws. Notice will be given in-app or via official channels. '
            'Continued use signifies acceptance of the updated AUP.'),
        SizedBox(height: 12),
        _H('Contact info'),
        _B('Organization: SLNSS  •  Website: slnss.org\n'
            'IT/Security contact: use the Help screen (email/phone) or the Incident module for urgent matters.\n'
            'Office address: see AUP Contact section in the Help screen.'),
        SizedBox(height: 12),
        _H('Feedback'),
        _B('If something is unclear, contact SLNSS. Constructive feedback improves training, privacy, and security outcomes.'),
        SizedBox(height: 48),
      ],
    );
  }
}

class _H extends StatelessWidget { final String t; const _H(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:16,fontWeight:FontWeight.w700)); }
class _B extends StatelessWidget { final String t; const _B(this.t,{super.key});
@override Widget build(BuildContext c)=>Text(t,style: const TextStyle(fontSize:14,height:1.55)); }
