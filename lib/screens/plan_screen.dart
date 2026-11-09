import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'main_shell.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = AppScope.of(context).plan;

    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Kế hoạch dành cho bạn',
          subtitle: 'Từng bữa ăn nhỏ, tiến gần mục tiêu lớn.',
        ),
        const StepBadge('BƯỚC 3 / 3'),        GreenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MỤC TIÊU NẠP MỖI NGÀY',
                style: TextStyle(fontSize: 11.5, color: AppColors.accent),
              ),
              const SizedBox(height: 14),
              Text(
                formatNumber(plan.kcal),
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'kcal / ngày · mức khởi đầu ước tính',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InfoRow('Cân nặng', plan.planWeight),
        InfoRow('Thời gian', plan.planDuration),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cân bằng mỗi bữa ăn',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              InfoRow('Đạm', '${plan.protein} g'),
              InfoRow('Tinh bột', '${plan.carbs} g'),
              InfoRow('Chất béo', '${plan.fat} g'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Caption(plan.planNote),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Bắt đầu hành trình',
          onPressed: () => openMainShell(context),
        ),
      ],
    );
  }
}
