import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../features/home/alarm_model.dart';

class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.alarmCard,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [

            Expanded(
              child: Text(
                alarm.formattedTime,
                style: AppTextStyles.alarmTime.copyWith(
                  color: alarm.isEnabled
                      ? AppColors.white
                      : AppColors.hintText,
                ),
              ),
            ),


            Text(
              alarm.formattedDate,
              style: AppTextStyles.alarmDate,
            ),
            const SizedBox(width: 12),

            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 46,
                height: 26,
                decoration: BoxDecoration(
                  color: alarm.isEnabled
                      ? AppColors.toggleActive
                      : const Color(0xFF2A2F5A),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: alarm.isEnabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}