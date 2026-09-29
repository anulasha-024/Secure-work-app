<div align="center">
  <img src="assets/icon/Icon1.png" alt="SecureWork app icon" width="110" />
  <h1>SecureWork</h1>
  <p><strong>Employee Security Awareness App</strong></p>
  <p>Learn safer habits. Test your knowledge. Understand workplace policies.</p>

  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
  ![Project](https://img.shields.io/badge/Project-Academic%20Prototype-64748B?style=flat-square)

  [Overview](#overview) · [Features](#features) · [Getting Started](#getting-started) · [Roadmap](#roadmap)
</div>

---

## Overview

**SecureWork** is a Flutter mobile application designed to improve cybersecurity awareness among office employees. It brings security tutorials, knowledge quizzes, workplace policies, and personal learning progress into one application.

The project focuses on everyday risks such as phishing emails, weak passwords, unsafe browsing, and insecure device use. It was developed as an academic security awareness project for an office environment.

> **Project status:** Academic prototype. Core learning and policy workflows are implemented in the source; several administration and communication features remain under development. This repository is not a production security certification.

## Features

| Area | Implemented functionality |
| --- | --- |
| **User accounts** | Email/password registration and sign-in using Firebase Authentication; verification email sent during registration. |
| **Security tutorials** | Four learning modules with completion tracking. |
| **Knowledge quizzes** | Four topic-based quizzes with five questions each, score feedback, and completion recorded on a full score. |
| **Workplace policies** | Six policy sections with per-user acceptance tracking. |
| **Policy download** | Download and open an Acceptable Use Policy PDF from Firebase Storage. |
| **Personal progress** | Profile views for tutorial, quiz, and policy progress. |
| **Navigation** | Dashboard and bottom navigation for key user sections. |

### Learning topics

| Topic | Learning focus |
| --- | --- |
| Password management | Strong passwords and safer account habits. |
| Email and phishing | Recognizing suspicious messages and phishing attempts. |
| Safe browsing | Safer website use and browsing practices. |
| Device security | Protecting devices and workplace information. |

### Policy sections

- Purpose and consent
- Who must follow the policy
- Prohibited use
- User responsibilities
- Reporting and enforcement
- Updates and contacts

## Technology Stack

| Technology | Purpose |
| --- | --- |
| Flutter and Dart | Application interface, navigation, and client logic |
| Firebase Authentication | Email/password account authentication |
| Cloud Firestore | User records, learning completion, and policy acceptance |
| Firebase Storage | Policy PDF storage |
| Shared Preferences | Local policy-acceptance caching |
| Dio | File downloads |
| Path Provider and OpenFilex | Local file storage and opening downloaded documents |

## User Journey

1. Create an account or sign in.
2. Open a security tutorial and mark it complete.
3. Take the matching quiz and achieve a full score to record completion.
4. Read and acknowledge workplace policies.
5. Review learning progress from the profile page.

## Getting Started

### Prerequisites

- Flutter SDK with Dart compatible with `^3.9.0`, as declared in `pubspec.yaml`.
- Android Studio or another configured Flutter development environment.
- An Android emulator or connected Android device.
- Your own Firebase project with Authentication, Firestore, and Storage configured.

Android is the focus of these instructions. Other platform folders exist, but their presence does not mean every platform has been configured or tested.

### 1. Clone the repository

```bash
git clone https://github.com/anulasha-024/Secure-work-app.git
cd Secure-work-app
flutter pub get
```

### 2. Configure Firebase

1. Register an Android app in your Firebase project using `sliit.lk.app`, or update the Android application ID and Firebase registration together.
2. Replace `android/app/google-services.json` with the configuration for your own Firebase project.
3. Enable **Email/Password** sign-in in Firebase Authentication.
4. Create a Cloud Firestore database and configure access rules for user data.
5. Configure Firebase Storage and upload a policy PDF. Update `_storagePath` in `lib/pages/policies/policies_page.dart` to match its object path.
6. Configure Storage access rules for the intended users.

The app currently initializes Firebase with `Firebase.initializeApp()` and relies on native platform configuration. Do not assume the repository's existing Firebase project is available for your use.

### 3. Check source-path casing

The repository uses `lib/pages/Password/`, while some imports use `pages/password/`. Make the folder name and all imports match exactly before building on a case-sensitive filesystem.

### 4. Run the application

```bash
flutter doctor
flutter devices
flutter run
```

### 5. Build an Android APK

After completing configuration and resolving any build issues:

```bash
flutter build apk --release
```

Expected output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The current Android release configuration uses debug signing. Configure your own release signing before distributing a production build.

## Source Guide

| Location | Contents |
| --- | --- |
| `lib/main.dart` | Firebase initialization and application routes |
| `lib/login_page.dart` / `lib/signup_page.dart` | Account screens |
| `lib/dashboard_page.dart` | Main dashboard |
| `lib/pages/Tutorials/` | Learning modules |
| `lib/pages/Quiezes/` | Quizzes and reusable quiz interface; folder spelling follows the repository |
| `lib/pages/policies/` | Policy pages and PDF download |
| `lib/pages/profile/` | User profile and progress interface |
| `lib/services/` | User bootstrap, tutorial progress, quiz progress, and policy acceptance |
| `lib/pages/admin/` | Administration interface and work-in-progress pages |
| `assets/` / `images/` | Icons and visual assets |

## Current Limitations

- Security Updates and Notifications currently display empty-state screens; a live feed and push notifications are not implemented.
- Several admin pages contain placeholders for content management, announcements, and incident handling.
- The admin guard checks a Firebase custom claim, while user-management code writes a Firestore role field. These mechanisms need alignment and trusted backend enforcement.
- Registration sends a verification email, but the current login flow does not enforce email verification.
- Firestore and Storage rules are not included in this repository; backend permissions must be configured and reviewed separately.
- Setup instructions are based on source inspection. A fresh build and end-to-end Firebase workflow have not been verified as part of this documentation update.

## Roadmap

- [ ] Complete admin content-management workflows.
- [ ] Connect security updates and announcements to live content.
- [ ] Implement notification delivery.
- [ ] Align role management with trusted backend authorization.
- [ ] Enforce email verification where required.
- [ ] Add version-controlled Firebase rules and meaningful automated tests.
- [ ] Add application screenshots and a short demonstration video.

## Project Links

- [Source repository](https://github.com/anulasha-024/Secure-work-app)
- [GitHub profile](https://github.com/anulasha-024)

---

<div align="center">
  <sub>SecureWork · Building everyday cybersecurity awareness at work.</sub>
</div>
