import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final left = AppState.waterGoal - state.waterMl;
    final canUndo =
        state.waterEntries.isNotEmpty && state.waterEntries.last.justAdded;

    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Thêm một ngụm mát',
          subtitle: 'Đã thêm 250 ml vào hôm nay.',
        ),
        const SizedBox(height: 24),
        AppCard(
          color: AppColors.water,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${formatNumber(state.waterMl)} ml',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                'Mục tiêu hằng ngày: ${formatNumber(AppState.waterGoal)} ml',
                style: const TextStyle(fontSize: 13.5),
              ),
              const SizedBox(height: 14),
              AppProgressBar(
                value: state.waterMl / AppState.waterGoal,
                color: AppColors.waterDeep,
                background: AppColors.surface,
              ),
              const SizedBox(height: 14),
              Text(
                left > 0
                    ? 'Còn ${formatNumber(left)} ml tới mục tiêu.'
                    : 'Bạn đã đạt mục tiêu nước hôm nay!',
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Lịch sử uống nước'),
              const SizedBox(height: 6),
              for (final entry in state.waterEntries.reversed)
                InfoRow(entry.justAdded ? 'Vừa xong' : entry.time, '+${entry.ml} ml'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Caption(
          'Mục tiêu nước là tùy chọn cá nhân. '
          'Bạn có thể điều chỉnh cho phù hợp.',
        ),
        const SizedBox(height: 20),
        AccentButton(
          label: 'Quay lại',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          label: 'Hoàn tác lần thêm này',
          onPressed: canUndo
              ? () {
                  state.undoLastWater();
                  showToast(context, 'Đã hoàn tác 250 ml');
                  Navigator.of(context).pop();
                }
              : null,
        ),
      ],
    );
  }
}
