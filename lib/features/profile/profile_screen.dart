import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/rounded_card.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:moveit/features/profile/privacy_policy_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = context.watch<AppProvider>().profileImagePath;

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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppTheme.spacingLg),

                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(64),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                              color: Colors.grey[300],
                            ),

                            child: ClipOval(
                              child: imagePath != null
                                  ? kIsWeb
                                        //  Web Image.network
                                        ? Image.network(
                                            imagePath,
                                            fit: BoxFit.cover,
                                            width: 128,
                                            height: 128,
                                          )
                                        //  Mobile Image.file
                                        : Image.file(
                                            File(imagePath),
                                            fit: BoxFit.cover,
                                            width: 128,
                                            height: 128,
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
                        ],
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
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                "Account Info",
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

                      // 🔔 Daily Reminder
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
                                  onChanged: (_) => provider.toggleReminder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      RoundedCard(
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
                        child: Row(
                          children: [
                            Icon(Icons.help_outline),
                            const SizedBox(width: 12),
                            const Expanded(child: Text("Help Centre")),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      RoundedCard(
                        child: Row(
                          children: [
                            Icon(Icons.gavel),
                            const SizedBox(width: 12),
                            const Expanded(child: Text("Community Rules")),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      RoundedCard(
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
                        child: Row(
                          children: [
                            Icon(Icons.mail_outline),
                            const SizedBox(width: 12),
                            const Expanded(child: Text("Contact Us")),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      RoundedCard(
                        child: Row(
                          children: [
                            Icon(Icons.person_remove_outlined),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text("Request Account Deletion"),
                            ),
                            const Icon(Icons.chevron_right),
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
                        onTap: () async {
                          await context.read<AuthProvider>().logout();
                          if (context.mounted) context.go(Routes.login);
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
