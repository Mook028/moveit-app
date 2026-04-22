import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/rounded_card.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart' as local_auth;
import 'edit_profile_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:moveit/features/profile/privacy_policy_page.dart';
import 'account_page.dart';
import 'package:moveit/services/notification_service.dart';
import 'change_password_page.dart';
import 'guidelines_page.dart';
import 'contact_us_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();

        Navigator.of(context).popUntil((route) => route.isFirst);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = context.watch<AppProvider>().profileImagePath;
    final imageBytes = context.watch<AppProvider>().profileImageBytes;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA8D5BA), Color(0xFFBFE3D0), Color(0xFFEAF5EF)],
          ),
        ),
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppTheme.spacingLg),

                      /// PROFILE IMAGE (แก้แล้ว ใช้ Firebase)
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(60),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: imageBytes != null
                              ? Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Center(
                                  child: Text(
                                    provider.user.name.isNotEmpty
                                        ? provider.user.name[0]
                                        : 'U',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B5E20),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Name and subtitle
                      Text(
                        provider.user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Wellness Enthusiast',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLg),

                      // Edit Profile button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.1,
                              ), //  เงาเบา ๆ
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),

                      // Settings cards

                      // 🧾 My Account
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My Account",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      RoundedCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                "Account ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 🔐 Settings & Security
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Settings & Security",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      //  Daily Reminder
                      RoundedCard(
                        child: SizedBox(
                          height: 25,
                          child: Row(
                            children: [
                              const Icon(Icons.notifications_none, size: 22),

                              const SizedBox(width: 12),

                              const Expanded(
                                child: Text(
                                  'Daily Reminders',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              Transform.scale(
                                scale: 0.85,
                                child: Switch(
                                  value: provider.reminderEnabled,
                                  onChanged: (value) async {
                                    provider.toggleReminder();
                                    if (!kIsWeb) {
                                      if (value) {
                                        await NotificationService.scheduleDaily(); // เปิด
                                      } else {
                                        await NotificationService.cancelAll(); //  ปิด
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      RoundedCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      RoundedCard(
                        child: Row(
                          children: [
                            const Icon(Icons.language),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Language",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Text(
                              "English UK",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 🆘 Support
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Support",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      RoundedCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GuidelinesPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.gavel),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Community Rules",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      RoundedCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.lock),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      RoundedCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ContactUsPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.mail_outline),
                            const SizedBox(width: 12),
                            const Expanded(child: Text("Contact Us")),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      RoundedCard(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //  ข้อความ
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "We're sorry to see you go. Once deleted, your account cannot be recovered.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  const Divider(height: 1),

                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        //  Cancel
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const VerticalDivider(width: 1),

                                        // OK
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              await _deleteAccount(context);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: Color(0xFF2E7D32),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.person_remove_outlined),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Request Account Deletion",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingSm),

                      RoundedCard(
                        backgroundColor: const Color(0xFFFFEBEE),
                        border: Border.all(
                          color: const Color(0xFFFFCDD2),
                          width: 1,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => LogoutDialog(),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Color(0xFFC62828),
                              size: 24,
                            ),
                            SizedBox(width: AppTheme.spacingSm),
                            Expanded(
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFC62828),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLg),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(current: Routes.profile),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 TEXT CONTENT
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                Text(
                  "Log Out",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 🔹 BUTTONS (แบบรูปที่ 2)
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),

              Container(width: 1, height: 50, color: Colors.grey[300]),

              Expanded(
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    await context.read<local_auth.AuthProvider>().logout();

                    if (context.mounted) {
                      context.go(Routes.login);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Color(0xFF2E7D32), // เขียว MoveIT
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
