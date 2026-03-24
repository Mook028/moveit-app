import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/rounded_card.dart';
import '../../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      if (provider.shouldNavigateToStats()) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.go(Routes.progress);
          }
        });
      }
    });
  }

  Color _getMoodColor(String? mood) {
    switch (mood) {
      case 'Energetic':
        return const Color(0xFFC8E6C9);
      case 'Normal':
        return const Color(0xFFFFF9C4);
      case 'Tired':
        return const Color(0xFFB0BEC5);
      default:
        return const Color(0xFFF1F8E9);
    }
  }

  Color _getMoodTextColor(String? mood) {
    switch (mood) {
      case 'Energetic':
        return const Color(0xFF1B5E20);
      case 'Normal':
        return const Color(0xFF827717);
      case 'Tired':
        return const Color(0xFF455A64);
      default:
        return const Color(0xFF558B2F);
    }
  }

  String _getMoodLabel(String? mood) {
    switch (mood) {
      case 'Energetic':
        return 'Feeling Powerful';
      case 'Normal':
        return 'Steady & Calm';
      case 'Tired':
        return 'Relax & Recharge';
      default:
        return 'Set your mood';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final moodColor = _getMoodColor(provider.selectedMood);
          final moodTextColor = _getMoodTextColor(provider.selectedMood);
          final moodLabel = _getMoodLabel(provider.selectedMood);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Mood header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacingLg,
                        horizontal: AppTheme.spacingMd,
                      ),
                      decoration: BoxDecoration(
                        color: moodColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: moodColor.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            moodLabel.toUpperCase(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: moodTextColor,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Today's specialized goals",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: moodTextColor.withAlpha(200),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // Task list
                    ...provider.tasks.map((t) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppTheme.spacingSm,
                        ),
                        child: RoundedCard(
                          onTap: () => provider.toggleTask(t.id),
                          child: Row(
                            children: [
                              // Checkmark circle
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: t.completed
                                        ? AppTheme.primary
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  color: t.completed
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                ),
                                child: t.completed
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: AppTheme.spacingSm),
                              // Task info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: t.completed
                                            ? Colors.grey[400]
                                            : Colors.grey[800],
                                        decoration: t.completed
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '${t.duration} mins • ${t.mood}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500],
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
                    }),

                    // Empty state
                    if (provider.tasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingLg * 3,
                        ),
                        child: Center(
                          child: Text(
                            'No tasks yet. Select a mood first!',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: AppTheme.spacingMd),

                    // Mark All Done button
                    if (provider.tasks.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            provider.markAllAsDone();
                            if (mounted) {
                              context.go(Routes.progress);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppTheme.primary,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLg,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingMd,
                            ),
                          ),
                          child: const Text(
                            'Mark All as Done',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
      bottomNavigationBar: const CustomBottomNav(current: Routes.home),
    );
  }
}
