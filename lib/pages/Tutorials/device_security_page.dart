import 'package:flutter/material.dart';
import 'widgets/tutorial_detail_shell.dart';
import 'package:app/services/tutorial_progress_service.dart';

class DeviceSecurityPage extends StatelessWidget {
  const DeviceSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialDetailShell(
      title: 'Device Security (Mobile & Laptop)',
      onCta: () async {
        await TutorialProgressService.markCompleted('device');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marked "Device Security" as complete')),
          );
          Navigator.pop(context);
        }
      },
      children: const [
        TTitle('Threats'),
        TSub('Lost/stolen devices, malicious apps, outdated OS, SIM-swap, USB drop attacks, and data loss.'),

        TSection('Learning goals',
            'Lock, encrypt, update, back up, locate/wipe.'),

        TSection('Essentials',
            '• Screen lock: strong PIN/passcode + biometrics; auto-lock ≤30–60s.\n'
                '• Encryption: on by default on modern Android/iOS; ensure BitLocker (Windows) / FileVault (macOS).\n'
                '• Updates: OS & apps auto; install promptly.\n'
                '• App hygiene: only official stores; review permissions; uninstall unused.\n'
                '• Backups: enable encrypted cloud or offline; test restore.\n'
                '• Find-My-Device: enable; know remote lock/wipe steps.\n'
                '• Network/Ports: disable Bluetooth when not used; block USB data on lock screen; avoid unknown chargers (“juice jacking”).\n'
                '• SIM security: set SIM PIN; watch for sudden “no service.”'),

        TSection('Platform quick-paths',
            '• Android: Settings → Security & privacy → Screen lock / Find My Device / Encryption.\n'
                '• iOS: Settings → Face/Touch ID & Passcode / Find My / Automatic Updates.\n'
                '• Windows: Settings → Privacy & Security → BitLocker / Find my device / Windows Update.\n'
                '• macOS: System Settings → Touch ID & Password / FileVault / Software Update / Find My.'),

        TSection('Lost device playbook',
            'Try locate/ring; if unrecoverable → remote-lock & wipe. Change passwords for email/critical apps; revoke sessions. '
                'Notify org (for MDM wipe) and carrier (SIM block). Rotate MFA and invalidate tokens.'),

        TSection('Disposal/transfer',
            'Sign out; factory reset; wipe/format; remove from account; destroy/sanitize drives if required.'),

        TSection('Team/Policy metrics',
            '% devices encrypted, patch latency, backup success rate, Find-My enabled rate.'),
      ],
    );
  }
}
