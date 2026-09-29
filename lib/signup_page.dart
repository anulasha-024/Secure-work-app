// lib/signup_page.dart
// ignore_for_file: unused_import

import 'package:app/pages/services/user_bootstrap.dart' hide ensureUserDoc;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// If this file is inside lib/pages/, use:  import 'package:app/services/user_bootstrap.dart';
import 'services/user_bootstrap.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // NEW: Role state
  final List<String> _roles = const ['user', 'admin'];
  String _selectedRole = 'user';

  bool _isLoading = false;
  bool _obscurePw = true;
  bool _obscurePw2 = true;

  // --- Helpers ---
  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String? _emailValidator(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
    if (!ok) return 'Enter a valid email';
    return null;
  }

  String? _nameValidator(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name is too short';
    return null;
  }

  String? _pwValidator(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Use at least 6 characters';
    return null;
  }

  String? _confirmValidator(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passwordController.text) return "Passwords don't match";
    return null;
  }

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    setState(() => _isLoading = true);
    try {
      // 1) Create Firebase Auth user
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // 2) Set display name (so ProfilePage can show it even if Firestore is empty)
      await cred.user?.updateDisplayName(name);

      // 3) Create/merge Firestore users/<uid> with the chosen role
      await ensureUserDoc(cred.user!, role: _selectedRole, displayName: name,);

      // 4) Send email verification (optional but recommended)
      await cred.user?.sendEmailVerification();

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Verify your email'),
          content: Text(
            'We sent a verification link to $email.\n'
                'Please check your inbox (and spam) to verify your account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // 5) Navigate (choose what fits your flow)
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          msg = 'That email address looks invalid.';
          break;
        case 'weak-password':
          msg = 'Please choose a stronger password.';
          break;
        case 'operation-not-allowed':
          msg = 'Email/password sign-in is disabled in Firebase Console.';
          break;
        default:
          msg = e.message ?? 'Sign up failed';
      }
      _toast(msg);
    } catch (e) {
      _toast('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _fieldDecoration(String hint, {Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffix,
      );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const black = Colors.black;
    final sub = Colors.grey[600];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        foregroundColor: black,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    const Text('Sign Up',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 12),

                // Illustration
                Center(
                  child: Image.asset(
                    'images/SIGN-IN.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  'Create Your Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                // Name
                const Text('Your Name',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: _nameValidator,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration('Name'),
                ),
                const SizedBox(height: 6),
                Text('your Account Name .',
                    style: TextStyle(color: sub, fontSize: 12)),
                const SizedBox(height: 18),

                // Email
                const Text('Email Address',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  validator: _emailValidator,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration('you@example.com'),
                ),
                const SizedBox(height: 6),
                Text("We'll never share your email.",
                    style: TextStyle(color: sub, fontSize: 12)),
                const SizedBox(height: 18),

                // Password
                const Text('Password',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  validator: _pwValidator,
                  obscureText: _obscurePw,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration(
                    'Enter your password',
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePw ? Icons.visibility_off : Icons.visibility,
                        color: black,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePw = !_obscurePw),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Any password you want',
                    style: TextStyle(color: sub, fontSize: 12)),
                const SizedBox(height: 18),

                // Confirm Password
                const Text('Confirm Password',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: _confirmValidator,
                  obscureText: _obscurePw2,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration(
                    'Confirm your password',
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePw2 ? Icons.visibility_off : Icons.visibility,
                        color: black,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePw2 = !_obscurePw2),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Retype password you entered',
                    style: TextStyle(color: sub, fontSize: 12)),
                const SizedBox(height: 18),

                // NEW: Role (Dropdown same style as fields)
                const Text('Role',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: _roles
                      .map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(r),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedRole = val ?? 'user'),
                  decoration: _fieldDecoration('Select role'),
                ),
                const SizedBox(height: 6),
                Text('Choose account role (default: user).',
                    style: TextStyle(color: sub, fontSize: 12)),
                const SizedBox(height: 26),

                // Buttons row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                        _isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: black, width: 1.2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          foregroundColor: black,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : const Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
