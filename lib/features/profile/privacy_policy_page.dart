import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Widget _buildSection({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F7F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "MoveIT Privacy Policy 🔐",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Last updated: April 2026",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            _buildSection(
              title: "1. Information We Collect",
              content:
                  "We may collect personal information such as your name, email address, and data you choose to input including mood and activity tracking.",
            ),

            _buildSection(
              title: "2. How We Use Your Information",
              content:
                  "Your information is used to improve app features, personalize your experience, and provide reminders if enabled.",
            ),

            _buildSection(
              title: "3. Data Protection",
              content:
                  "We store your data securely and do not sell or share your personal information with third parties.",
            ),

            _buildSection(
              title: "4. User Control",
              content:
                  "You can update or delete your information, manage notifications, and stop using the app at any time.",
            ),

            _buildSection(
              title: "5. Not Medical Advice",
              content:
                  "MoveIT is for general wellness purposes only and is not a substitute for professional medical advice.",
            ),

            _buildSection(
              title: "6. Changes to This Policy",
              content:
                  "We may update this policy occasionally. Changes will be reflected within the app.",
            ),

            _buildSection(
              title: "7. Contact Us",
              content:
                  "If you have any questions or concerns regarding this policy, please feel free to contact us at support@moveit.app",
            ),
          ],
        ),
      ),
    );
  }
}
