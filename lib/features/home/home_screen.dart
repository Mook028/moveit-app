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

  LinearGradient _getMoodBackgroundGradient(String? mood) {
    switch (mood?.toLowerCase()) {
      case 'energetic':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFA5D6A7), Color(0xFFC8E6C9), Color(0xFFE8F5E9)],
        );
      case 'normal':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF59D), Color(0xFFFFF9C4), Color(0xFFFFFDE7)],
        );
      case 'tired':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF90CAF9), Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF1F8E9), Color(0xFFF7FBEF), Color(0xFFFFFFFF)],
        );
    }
  }

  Color _getMoodActionColor(String? mood) {
    switch (mood?.toLowerCase()) {
      case 'energetic':
        return const Color(0xFF2E7D32); // dark green
      case 'normal':
        return const Color(0xFF9A7D0A); // dark yellow
      case 'tired':
        return const Color(0xFF1565C0); // dark blue
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBody: true,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final showMoodContent =
              provider.isMoodConfirmed && provider.selectedMood != null;
          final moodLabel = showMoodContent
              ? _getMoodLabel(provider.selectedMood)
              : 'Set your mood';
          final moodBackgroundGradient = _getMoodBackgroundGradient(
            showMoodContent ? provider.selectedMood : null,
          );
          final moodActionColor = showMoodContent
              ? _getMoodActionColor(provider.selectedMood)
              : AppTheme.primary;

          return Container(
            decoration: BoxDecoration(gradient: moodBackgroundGradient),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingLg,
                          horizontal: AppTheme.spacingMd,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(82),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withAlpha(115),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(18),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
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
                                color: const Color(0xFF1B5E20),
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Today's specialized goals",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLg),

                      if (showMoodContent) ...[
                        ...provider.tasks.map((t) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppTheme.spacingSm,
                            ),
                            child: RoundedCard(
                              onTap: () {
                                provider.toggleTask(t.id);

                                // ดึงค่าใหม่หลัง toggle
                                final updatedTasks = context
                                    .read<AppProvider>()
                                    .tasks;
                                final completed = updatedTasks
                                    .where((t) => t.completed)
                                    .length;

                                if (updatedTasks.isEmpty) {
                                  context.read<AppProvider>().setDayStatus(
                                    DateTime.now(),
                                    DayStatus.none,
                                  );
                                } else if (completed == updatedTasks.length) {
                                  context.read<AppProvider>().setDayStatus(
                                    DateTime.now(),
                                    DayStatus.allComplete,
                                  );
                                } else if (completed > 0) {
                                  context.read<AppProvider>().setDayStatus(
                                    DateTime.now(),
                                    DayStatus.someComplete,
                                  );
                                } else {
                                  context.read<AppProvider>().setDayStatus(
                                    DateTime.now(),
                                    DayStatus.inProgress,
                                  );
                                }
                              },
                              child: Row(
                                children: [
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
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

                        const SizedBox(height: AppTheme.spacingMd),

                        if (provider.tasks.isNotEmpty) ...[
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                provider.markAllAsDone();

                                provider.setDayStatus(
                                  DateTime.now(),
                                  DayStatus.allComplete,
                                );

                                if (mounted) {
                                  context.go(Routes.progress);
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: moodActionColor,
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
                              child: Text(
                                'Mark All as Done',
                                style: TextStyle(
                                  color: moodActionColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextButton(
                            onPressed: () {
                              context.read<AppProvider>().unlockMood();
                              context.go(Routes.mood);
                            },
                            child: const Text(
                              "Change Mood",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ] else ...[
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
                      ],

                      const SizedBox(height: AppTheme.spacingLg),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: const CustomBottomNav(current: Routes.home),
      ),
    );
  }
}
