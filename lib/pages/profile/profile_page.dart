import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Reads policy acceptance progress (Firestore-backed per user)
import 'package:app/services/policy_acceptance_service.dart' as policy_service;
// tutorials completion progress (Firestore-backed per user)
import 'package:app/services/tutorial_progress_service.dart' as tute_service;
// quizzes completion progress (Firestore-backed per user)
import 'package:app/services/quiz_progress_service.dart' as quiz_service;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const _AuthRequired();
    }

    final users = FirebaseFirestore.instance.collection('users').doc(user.uid);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Account', style: TextStyle(fontWeight: FontWeight.w600)),
      ),

      // bottom navigation (pill style)
      bottomNavigationBar: _BottomNavBar(
        currentIndex: 2, // 0=Home, 1=Notifications, 2=Profile (this page)
        onTap: (i) {
          switch (i) {
            case 0:
              if (ModalRoute.of(context)?.settings.name != '/dashboard') {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
              break;
            case 1:
              if (ModalRoute.of(context)?.settings.name != '/notifications') {
                Navigator.pushReplacementNamed(context, '/notifications');
              }
              break;
            case 2:
            default:
              break; // already here
          }
        },
      ),

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: users.snapshots(),
        builder: (context, snap) {
          final data = snap.data?.data() ?? {};

          // Auth fields (fallbacks)
          final name  = (data['displayName'] ?? user.displayName ?? 'Get account name') as String;
          final email = (data['email'] ?? user.email ?? 'account email') as String;
          final role  = (data['role'] ?? 'user') as String;
          final photo = user.photoURL;

          // NEW: admin flag for showing the Admin Console button
          final bool isAdmin = role == 'admin';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24 + 80), // extra bottom padding for the nav bar
            child: Column(
              children: [
                // Header banner
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBFC4CC),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: const Offset(0, 40),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: photo != null ? NetworkImage(photo) : null,
                        child: photo == null
                            ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                        )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 52),

                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF3D34B4),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // Admin Console button (visible only for admins)
                if (isAdmin) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/admin'),
                      icon: const Icon(Icons.admin_panel_settings_rounded),
                      label: const Text('Admin Console'),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Info card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12, offset: const Offset(0, 6)),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('e-mail'),
                      _ReadOnlyField(value: email),
                      const SizedBox(height: 12),
                      const _FieldLabel('Role'),
                      _ReadOnlyField(value: role),

                      const SizedBox(height: 18),
                      const _FieldLabel('tutorials complete'),
                      // Firestore-driven (25% per tutorial)
                      const _TutorialsBar(),

                      const SizedBox(height: 10),
                      const _FieldLabel('quizzes complete'),
                      // Firestore-driven (25% per quiz)
                      const _QuizzesBar(),

                      const SizedBox(height: 10),
                      const _FieldLabel('Accepted policies'),
                      // Firestore-driven (per user)
                      const _AcceptedPoliciesBar(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

double _asDouble(dynamic x) {
  if (x is int) return x.toDouble();
  if (x is double) return x.clamp(0.0, 1.0);
  return 0.0;
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Color(0xFF9EA3AE), letterSpacing: .1),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String value;
  const _ReadOnlyField({required this.value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE6E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFDCDDE2)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: const TextStyle(fontSize: 14.5),
    );
  }
}

class _ProgressSlider extends StatefulWidget {
  final double value; // 0.0 .. 1.0
  final Color activeColor;
  const _ProgressSlider({required this.value, required this.activeColor});

  @override
  State<_ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<_ProgressSlider> {
  late double _v;

  @override
  void initState() {
    super.initState();
    _v = widget.value.clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(covariant _ProgressSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _v = widget.value.clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: widget.activeColor,
        inactiveTrackColor: const Color(0xFFE8E9ED),
        thumbColor: widget.activeColor,
        overlayShape: SliderComponentShape.noOverlay,
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
      child: Slider(
        value: _v,
        min: 0,
        max: 1,
        divisions: 100,
        onChanged: (_) {}, // display-only
      ),
    );
  }
}

/// Live bar that reflects tutorial completions from Firestore (per user)
class _TutorialsBar extends StatelessWidget {
  const _TutorialsBar({super.key});

  static const int _totalTutorials = 4; // → 25% per tutorial

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: tute_service.TutorialProgressService
          .progressStream(totalTutorials: _totalTutorials),
      builder: (context, snap) {
        final p = (snap.data ?? 0).clamp(0.0, 1.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProgressSlider(value: p, activeColor: const Color(0xFFE16A37)),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(p * 100).round()}% complete',
                style: const TextStyle(fontSize: 12, color: Color(0xFF9EA3AE)),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Live bar that reflects quiz completions from Firestore (per user)
class _QuizzesBar extends StatelessWidget {
  const _QuizzesBar({super.key});
  static const int _totalQuizzes = 4; // → 25% per quiz

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: quiz_service.QuizProgressService.progressStream(total: _totalQuizzes),
      builder: (context, snap) {
        final p = (snap.data ?? 0).clamp(0.0, 1.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProgressSlider(value: p, activeColor: const Color(0xFF3453FF)),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(p * 100).round()}% complete',
                style: const TextStyle(fontSize: 12, color: Color(0xFF9EA3AE)),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Live bar that reflects policy acceptances from Firestore (per user)
class _AcceptedPoliciesBar extends StatelessWidget {
  const _AcceptedPoliciesBar({super.key});

  // Choose: 5 → 20% per card (your figma), or 6 → even split across 6 cards
  static const int _totalPoliciesForBar = 5;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: policy_service.PolicyAcceptanceService
          .progressStream(totalPolicies: _totalPoliciesForBar),
      builder: (context, snap) {
        final progress = (snap.data ?? 0).clamp(0.0, 1.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProgressSlider(value: progress, activeColor: const Color(0xFF20BF55)),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(progress * 100).round()}% complete',
                style: const TextStyle(fontSize: 12, color: Color(0xFF9EA3AE)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuthRequired extends StatelessWidget {
  const _AuthRequired();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: const Center(
        child: Text('Please sign in to view your profile.'),
      ),
    );
  }
}

// ---- shared bottom nav (pill style) ----
class _BottomNavBar extends StatelessWidget {
  final int currentIndex; // 0=Home, 1=Notifications, 2=Profile
  final ValueChanged<int> onTap;
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color bg = Colors.white;
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE6E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.notifications_none_rounded,
              label: 'Notifications',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedBg = const Color(0xFFEFF2FF);
    final selectedFg = const Color(0xFF3D34B4);
    final normalFg = const Color(0xFF8C8F98);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: selected ? selectedFg : normalFg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? selectedFg : normalFg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
