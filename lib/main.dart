// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:app/start_page.dart';
import 'package:app/login_page.dart';
import 'package:app/signup_page.dart';
import 'package:app/dashboard_page.dart' show DashboardPage;

// Password flows
import 'package:app/pages/password/forgot_password_page.dart';
import 'package:app/pages/password/new_password_page.dart';
import 'package:app/pages/password/password_reset_success_page.dart';

// Feature pages
import 'package:app/pages/Tutorials/tutorials_page.dart';
import 'package:app/pages/Quiezes/quizzes_page.dart';
import 'package:app/pages/policies/policies_page.dart';
import 'package:app/pages/updates/security_updates_page.dart';
import 'package:app/pages/profile/profile_page.dart';
import 'package:app/pages/notifications/notifications_page.dart';

// Policies: detail pages (6)
import 'package:app/pages/policies/purpose_consent_page.dart';
import 'package:app/pages/policies/who_must_follow_page.dart';
import 'package:app/pages/policies/prohibited_use_page.dart';
import 'package:app/pages/policies/responsibilities_page.dart';
import 'package:app/pages/policies/reporting_enforcement_page.dart';
import 'package:app/pages/policies/updates_contacts_page.dart';

// Tutorials: detail pages (4)
import 'package:app/pages/Tutorials/password_management_page.dart';
import 'package:app/pages/Tutorials/email_phishing_page.dart';
import 'package:app/pages/Tutorials/safe_browsing_page.dart';
import 'package:app/pages/Tutorials/device_security_page.dart';

// Quizzes: detail pages (4)
import 'package:app/pages/Quiezes/passwords_quiz_page.dart';
import 'package:app/pages/Quiezes/phishing_quiz_page.dart';
import 'package:app/pages/Quiezes/browsing_quiz_page.dart';
import 'package:app/pages/Quiezes/device_quiz_page.dart';

// Admin console (guarded)
import 'package:app/pages/admin/admin_only.dart';
import 'package:app/pages/admin/admin_dashboard_page.dart';
import 'package:app/pages/admin/users/admin_users_page.dart';
import 'package:app/pages/admin/content/admin_policies_page.dart';
import 'package:app/pages/admin/content/admin_tutorials_page.dart';
import 'package:app/pages/admin/content/admin_quizzes_page.dart';
import 'package:app/pages/admin/incidents/admin_incidents_page.dart';
import 'package:app/pages/admin/announce/admin_announcements_page.dart';

// Firestore bootstrap
import 'package:app/services/user_bootstrap.dart'; // ensureUserDoc

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Auto-create/merge users/<uid> when signed in
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      ensureUserDoc(user);
    }
  });

  // ✅ No DevicePreview here
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Initial route
      initialRoute: '/',

      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/dashboard': (context) => DashboardPage(),

        // Password flows
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/new-password': (context) => NewPasswordPage(),
        '/password-reset-success': (context) => PasswordResetSuccessPage(),

        // Main sections
        '/tutorials': (context) => const TutorialsPage(),
        '/quizzes': (context) => const QuizzesPage(),
        '/policies': (_) => const PoliciesPage(),
        '/security-updates': (_) => const SecurityUpdatesPage(),
        '/profile': (_) => const ProfilePage(),
        '/notifications': (_) => const NotificationsPage(),

        // Tutorial detail pages
        '/tutorial/passwords': (_) => const PasswordManagementPage(),
        '/tutorial/phishing': (_) => const EmailPhishingPage(),
        '/tutorial/browsing': (_) => const SafeBrowsingPage(),
        '/tutorial/device': (_) => const DeviceSecurityPage(),

        // Quiz pages
        '/quiz/passwords': (_) => const PasswordsQuizPage(),
        '/quiz/phishing': (_) => const PhishingQuizPage(),
        '/quiz/browsing': (_) => const BrowsingQuizPage(),
        '/quiz/device': (_) => const DeviceQuizPage(),

        // Admin (guarded)
        '/admin': (_) => const AdminOnly(child: AdminDashboardPage()),
        '/admin/users': (_) => const AdminOnly(child: AdminUsersPage()),
        '/admin/policies': (_) => const AdminOnly(child: AdminPoliciesPage()),
        '/admin/tutorials': (_) => const AdminOnly(child: AdminTutorialsPage()),
        '/admin/quizzes': (_) => const AdminOnly(child: AdminQuizzesPage()),
        '/admin/incidents': (_) => const AdminOnly(child: AdminIncidentsPage()),
        '/admin/announcements': (_) => const AdminOnly(child: AdminAnnouncementsPage()),
      },

      // Pattern routes for policy details
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        if (name.startsWith('/policy/')) {
          final id = name.split('/').last;
          switch (id) {
            case 'purpose_consent':
              return MaterialPageRoute(builder: (_) => const PurposeConsentPage());
            case 'who_follow':
              return MaterialPageRoute(builder: (_) => const WhoMustFollowPage());
            case 'prohibited_use':
              return MaterialPageRoute(builder: (_) => const ProhibitedUsePage());
            case 'responsibilities':
              return MaterialPageRoute(builder: (_) => const ResponsibilitiesPage());
            case 'reporting_enforcement':
              return MaterialPageRoute(builder: (_) => const ReportingEnforcementPage());
            case 'updates_contacts':
              return MaterialPageRoute(builder: (_) => const UpdatesContactsPage());
          }
        }
        return null; // fall back to static routes
      },
    );
  }
}
