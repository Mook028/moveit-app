import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MoodButton extends StatelessWidget {
  final String mood;
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const MoodButton({
    super.key,
    required this.mood,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Energetic':
        return '⚡';
      case 'Normal':
        return '😊';
      case 'Tired':
        return '🧘';
      default:
        return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: isSelected
                  ? Border.all(color: AppTheme.primary, width: 4)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withAlpha(100),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                _getMoodEmoji(mood),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppTheme.primary : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
