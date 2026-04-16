import 'package:flutter/material.dart';

class GuidelinesPage extends StatelessWidget {
  const GuidelinesPage({super.key});

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
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
        title: const Text("Guidelines", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "MoveIT App Guidelines 💚",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildCard(
              icon: Icons.favorite,
              title: "Use the App for Your Well-being",
              description:
                  "This app is designed to support your mental and physical well-being. Use it to build positive habits and improve yourself.",
            ),

            _buildCard(
              icon: Icons.psychology,
              title: "Be Honest with Yourself",
              description:
                  "Track your mood and activities honestly so the app can provide more accurate insights and suggestions.",
            ),

            _buildCard(
              icon: Icons.spa,
              title: "Progress Takes Time",
              description:
                  "Growth takes time. Don’t rush or pressure yourself. Improve step by step.",
            ),

            _buildCard(
              icon: Icons.notifications,
              title: "Use Reminders Wisely",
              description:
                  "Adjust notifications to suit your lifestyle so they help you without becoming overwhelming.",
            ),

            _buildCard(
              icon: Icons.lock,
              title: "Protect Your Data",
              description:
                  "Do not share your personal information. Always use a secure password to protect your account.",
            ),

            _buildCard(
              icon: Icons.warning_amber_rounded,
              title: "Not Medical Advice",
              description:
                  "This app is not a medical service. If you have health concerns, please consult a professional.",
            ),
          ],
        ),
      ),
    );
  }
}
