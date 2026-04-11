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

  ({Color start, Color end, Color glow}) _getMoodPalette(String mood) {
    switch (mood) {
      case 'Energetic':
        return (
          start: const Color(0xFF34D058),
          end: const Color(0xFF1FA24A),
          glow: const Color(0xFF3AD66D),
        );
      case 'Normal':
        return (
          start: const Color(0xFFF7C948),
          end: const Color(0xFFE8A61A),
          glow: const Color(0xFFFFD970),
        );
      case 'Tired':
        return (
          start: const Color(0xFF6EB7FF),
          end: const Color(0xFF3A8FDD),
          glow: const Color(0xFF8DC9FF),
        );
      default:
        return (start: color, end: color, glow: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _getMoodPalette(mood);

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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [palette.start, palette.end],
              ),
              border: Border.all(
                color: isSelected
                    ? palette.glow.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.55),
                width: isSelected ? 3.0 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isSelected ? 0.22 : 0.14),
                  blurRadius: isSelected ? 18 : 10,
                  offset: Offset(0, isSelected ? 10 : 6),
                ),
                if (isSelected)
                  BoxShadow(
                    color: palette.glow.withValues(alpha: 0.58),
                    blurRadius: 26,
                    spreadRadius: 4,
                  ),
              ],
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.28),
                      Colors.white.withValues(alpha: 0.10),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _getMoodEmoji(mood),
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
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
