import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/rounded_card.dart';
import '../../widgets/custom_bottom_nav.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            final inProgress = provider.isMoodConfirmed
                ? provider.tasks.where((t) => !t.completed).length
                : 0;
            final completed = provider.isMoodConfirmed
                ? provider.tasks.where((t) => t.completed).length
                : 0;

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
                      // Top section: Greeting and Avatar
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppTheme.spacingMd,
                          bottom: AppTheme.spacingLg,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${provider.user.name} 👋',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primary,
                              child: Text(
                                provider.user.name[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Streak Card
                      StreakCard(streak: provider.dailyStreak),

                      const SizedBox(height: AppTheme.spacingLg),

                      // Task Summary Section
                      Row(
                        children: [
                          Expanded(
                            child: TaskSummaryCard(
                              title: 'Completed',
                              count: completed,
                              color: Colors.green,
                              icon: Icons.check_circle,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(
                            child: TaskSummaryCard(
                              title: 'In Progress',
                              count: inProgress,
                              color: Colors.orange,
                              icon: Icons.pending,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingLg),

                      // Calendar Section
                      CalendarWidget(),

                      const SizedBox(height: AppTheme.spacingLg),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(current: Routes.progress),
    );
  }
}

class StreakCard extends StatelessWidget {
  final int streak;

  const StreakCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE8F5E8),
            Color(0xFFF3E5F5),
          ], // light green to light purple
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Streak',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$streak days',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your current streak',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.track_changes, size: 48, color: Color(0xFF4CAF50)),
        ],
      ),
    );
  }
}

class TaskSummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const TaskSummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = title == 'Completed';
    final accentColor = isCompleted
        ? const Color(0xFF2E7D32) // richer green
        : const Color(0xFFEF6C00); // stronger orange
    final cardBackground = isCompleted
        ? const Color(0xFFE4F3E8)
        : const Color(0xFFFFEFE2);

    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: accentColor.withAlpha(90), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: RoundedCard(
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent, width: 0),
        child: Row(
          children: [
            Icon(icon, color: accentColor, size: 24),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: accentColor, size: 16),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  // Mock data for completed/in progress dates
  final Set<DateTime> allCompleteDates = {
    DateTime(2024, 3, 1),
    DateTime(2024, 3, 5),
    DateTime(2024, 3, 10),
  };
  final Set<DateTime> someCompleteDates = {
    DateTime(2024, 3, 2),
    DateTime(2024, 3, 7),
    DateTime(2024, 3, 12),
  };
  final Set<DateTime> inProgressDates = {
    DateTime(2024, 3, 3),
    DateTime(2024, 3, 8),
    DateTime(2024, 3, 15),
  };

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(
                          currentMonth.year,
                          currentMonth.month - 1,
                        );
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(
                          currentMonth.year,
                          currentMonth.month + 1,
                        );
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Days of week
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: _getDaysInMonth(currentMonth),
            itemBuilder: (context, index) {
              final day = index + 1;
              final date = DateTime(currentMonth.year, currentMonth.month, day);
              final isSelected =
                  date.day == selectedDate.day &&
                  date.month == selectedDate.month &&
                  date.year == selectedDate.year;

              Color? backgroundColor;
              if (allCompleteDates.contains(date)) {
                backgroundColor = const Color(0xFF166534); // dark green
              } else if (someCompleteDates.contains(date)) {
                backgroundColor = const Color(0xFF86EFAC); // light green
              } else if (inProgressDates.contains(date)) {
                backgroundColor = const Color(
                  0xFFFFD54F,
                ); // light orange/yellow
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(color: AppTheme.primary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: backgroundColor != null
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('All complete', const Color(0xFF166534)),
              _buildLegendItem('Some complete', const Color(0xFF86EFAC)),
              _buildLegendItem('In progress', const Color(0xFFFFD54F)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  int _getDaysInMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }
}
