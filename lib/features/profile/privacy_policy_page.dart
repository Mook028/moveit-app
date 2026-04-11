import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for MoveIT',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Effective Date: April 11, 2026',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text(
                'MoveIT respects your privacy. This policy explains what information we collect, how we use it, and your rights.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'Information We Collect',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Account information: email address and password.\n- Activity information: movement and exercise history.\n- Device permissions: camera, storage, optional location.\n- Basic technical data for app performance.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'How We Use Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- To manage your account\n- To provide app features\n- To improve performance\n- To ensure security',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'Data Storage and Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Data is stored securely using Firebase\n- We apply standard security practices',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'User Rights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Access and update your data\n- Request account deletion\n- Control permissions in device settings',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'Third-party Services (Firebase)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- We use Firebase for authentication and storage',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'Changes to This Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- We may update this policy when needed',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
