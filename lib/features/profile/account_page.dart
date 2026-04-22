import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    //  ดึงวันที่สมัครจริง
    final createdAt = user?.metadata.creationTime;

    //  format วันที่
    final formattedDate = createdAt != null
        ? DateFormat('d MMM yyyy').format(createdAt)
        : "-";

    //  email จริง
    final email = user?.email ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xFFE6F7F0),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Account ",
          style: TextStyle(color: Color(0xFF1B5E20)),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Title
            const Text(
              "Profile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            //  Email Card
            _infoCard(title: "Email", value: email),

            const SizedBox(height: 16),

            //  Account Created Card
            _infoCard(title: "Account Created", value: formattedDate),
          ],
        ),
      ),
    );
  }

  //  reusable card
  Widget _infoCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBEE1C9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          // value
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
