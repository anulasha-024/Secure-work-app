// lib/pages/password/password_reset_success_page.dart
import 'package:flutter/material.dart';

class PasswordResetSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'images/Pass-reset.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 40),

              Text(
                'Password reset successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'You can now login with your new password.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to login page, removing all previous routes
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                            (route) => false
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Proceed to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}