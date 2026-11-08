import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'plan_screen.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final plan = state.plan;

    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Bạn muốn thay đổi gì?',
          subtitle: 'Một mục tiêu vừa sức, một hành trình bền lâu.',
        ),
        const StepBadge('BƯỚC 2 / 3'),
        for (final option in _options)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _GoalOption(
              option: option,
              selected: state.goal == option.goal,
              onTap: () => state.setGoal(option.goal),
            ),
          ),
        ValueCard(label: 'Cân nặng mong muốn', value: plan.targetWeight),
        ValueCard(label: 'Thời gian mục tiêu', value: plan.targetDuration),
        Caption(plan.goalNote),
        const SizedBox(height: 20),
        AccentButton(
          label: 'Xem kế hoạch của tôi',
          onPressed: () => pushScreen(context, const PlanScreen()),
        ),
      ],
    );
  }
}

class _OptionData {
  const _OptionData(this.goal, this.icon, this.title, [this.subtitle]);

  final Goal goal;
  final String icon;
  final String title;
  final String? subtitle;
}

const _options = [
  _OptionData(Goal.lose, '✓', 'Giảm cân', 'Giảm mỡ, giữ thói quen tốt'),
  _OptionData(Goal.gain, '›', 'Tăng cân'),
  _OptionData(Goal.healthy, '♡', 'Ăn uống lành mạnh'),
];

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _OptionData option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.ink;
    // "Giảm cân" khi không chọn hiển thị dạng tiêu đề + mô tả, không có icon.
    final showIcon = selected || option.subtitle == null;

    return AppCard(
      color: selected ? AppColors.primary : AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showIcon) ...[
                Text(option.icon, style: TextStyle(fontSize: 18, color: fg)),
                const SizedBox(width: 12),
              ],
              Text(
                option.title,
                style: TextStyle(
                  fontSize: selected || option.subtitle != null ? 19 : 17,
                  fontWeight: option.subtitle != null || selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
          if (option.subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              option.subtitle!,
              style: TextStyle(
                fontSize: 12.5,
                color: selected ? AppColors.accent : AppColors.ink,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
