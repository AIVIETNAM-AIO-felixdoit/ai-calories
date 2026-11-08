import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'running_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  static const _steps = 6420;
  static const _stepGoal = 8000;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return AppScreen(
      topBar: const AppTopBar(showBack: false, actionLabel: 'HỒ SƠ ›'),
      children: [
        const ScreenHeader(
          title: 'Vận động hôm nay',
          subtitle: 'Mỗi bước chân đều có ý nghĩa.',
        ),
        const SizedBox(height: 22),
        GreenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CALORIES OUT · VẬN ĐỘNG',
                style: TextStyle(fontSize: 11, color: AppColors.accent),
              ),
              const SizedBox(height: 14),
              Text(
                '${state.activityKcal} kcal',
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Năng lượng từ các hoạt động đã ghi nhận',
                style: TextStyle(fontSize: 12.5, color: Colors.white),
              ),
              const SizedBox(height: 14),
              const AppProgressBar(
                value: _steps / _stepGoal,
                color: AppColors.accent,
                background: Color(0xFFEAF0E5),
              ),
              const SizedBox(height: 14),
              Text(
                '${formatNumber(_steps)} bước  /  '
                'mục tiêu ${formatNumber(_stepGoal)} bước',
                style: const TextStyle(fontSize: 13, color: AppColors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          label: 'Bắt đầu chạy bộ',
          onPressed: () => pushScreen(context, const RunningScreen()),
        ),
        const SizedBox(height: 16),
        AppCard(
          color: AppColors.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bạn đã vận động ${state.activityMinutes} phút',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                'Calo vận động là ước tính và chưa bao gồm năng lượng '
                'cơ thể dùng khi nghỉ.',
                style: TextStyle(fontSize: 13, color: AppColors.muted, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionTitle('Lịch sử chạy bộ'),
        const SizedBox(height: 14),
        for (final run in state.runs) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        run.label,
                        style: const TextStyle(fontSize: 15, color: AppColors.muted),
                      ),
                    ),
                    Text(
                      '${run.kcal} kcal',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${run.km}   ·   ${run.minutes} phút   ·   ${run.pace}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
