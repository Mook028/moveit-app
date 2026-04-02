import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/mood_button.dart';
import '../../widgets/rounded_card.dart';
import '../../widgets/custom_bottom_nav.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppTheme.spacingMd,
                          bottom: AppTheme.spacingLg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello ${provider.user.name}!',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'How are you feeling today?',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Mood buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingLg,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MoodButton(
                              mood: 'Energetic',
                              label: 'Energetic',
                              color: AppTheme.accentEnergetic,
                              isSelected: provider.selectedMood == 'Energetic',
                              onTap: () => provider.setMood('Energetic'),
                            ),
                            MoodButton(
                              mood: 'Normal',
                              label: 'Normal',
                              color: AppTheme.accentNormal,
                              isSelected: provider.selectedMood == 'Normal',
                              onTap: () => provider.setMood('Normal'),
                            ),
                            MoodButton(
                              mood: 'Tired',
                              label: 'Tired',
                              color: AppTheme.accentTired,
                              isSelected: provider.selectedMood == 'Tired',
                              onTap: () => provider.setMood('Tired'),
                            ),
                          ],
                        ),
                      ),

                      // Streak card
                      RoundedCard(
                        backgroundColor: Colors.white.withAlpha(204),
                        padding: const EdgeInsets.all(AppTheme.spacingMd),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppTheme.spacingSm),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusLg,
                                ),
                              ),
                              child: const Text(
                                '🔥',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Streak',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${provider.dailyStreak} Days',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B5E20),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLg),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: provider.selectedMood != null
                              ? () {
                                  context.read<AppProvider>().confirmMood();
                                  context.go(Routes.home);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: provider.selectedMood != null
                                ? AppTheme.primary
                                : Colors.grey[300],
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingMd,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLg,
                              ),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: provider.selectedMood != null
                                  ? Colors.white
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingSm),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(current: Routes.mood),
    );
  }
}
