import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/rounded_card.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<AppProvider>(
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
                          child: Center(
                            child: Text(
                              provider.user.name[0],
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
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
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // Settings cards
                    RoundedCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLg,
                              ),
                            ),
                            child: const Icon(
                              Icons.notifications_none,
                              color: Color(0xFF1976D2),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          const Expanded(
                            child: Text(
                              'Daily Reminders',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                          Switch(
                            value: provider.reminderEnabled,
                            onChanged: (_) => provider.toggleReminder(),
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppTheme.primary,
                            inactiveTrackColor: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingSm),

                    RoundedCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E5F5),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLg,
                              ),
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF7B1FA2),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          const Expanded(
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                            size: 20,
                          ),
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
      bottomNavigationBar: const CustomBottomNav(current: Routes.profile),
    );
  }
}
