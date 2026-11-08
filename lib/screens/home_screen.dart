import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';
import 'history_screen.dart';
import 'scan_screen.dart';
import 'water_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return AppScreen(
      topBar: const AppTopBar(showBack: false),
      children: [
        const Text(
          'Chào Giang,',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Hôm nay, mình ăn uống cân bằng nhé.',
          style: TextStyle(fontSize: 14, color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        _EnergyCard(state: state),
        const SizedBox(height: 16),
        const Row(
          children: [
            _MacroCard(label: 'PROTEIN', value: '45g'),
            SizedBox(width: 10),
            _MacroCard(label: 'CARBS', value: '120g'),
            SizedBox(width: 10),
            _MacroCard(label: 'FAT', value: '35g'),
          ],
        ),
        const SizedBox(height: 16),
        _WaterCard(
          current: state.waterMl,
          onAdd: () {
            state.addWater();
            pushScreen(context, const WaterScreen());
          },
        ),
        const SizedBox(height: 18),
        PrimaryButton(
          label: '+  Chụp / tải bữa ăn',
          onPressed: () => pushScreen(context, const ScanScreen()),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(child: SectionTitle('Bữa ăn hôm nay')),
            GestureDetector(
              onTap: () => pushScreen(context, const HistoryScreen()),
              child: const Text(
                'Lịch sử ảnh ›',
                style: TextStyle(fontSize: 12.5, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (state.lunchSaved) ...[
          MealTile(
            title: 'Cơm gà & rau xanh',
            subtitle: 'Bữa trưa · 12:30',
            kcal: AppState.lunchKcal,
            onTap: () => pushScreen(context, const DetailScreen()),
          ),
          const SizedBox(height: 12),
        ],
        const MealTile(
          title: 'Phở bò',
          subtitle: 'Bữa sáng · 07:30',
          kcal: AppState.breakfastKcal,
          showImage: false,
        ),
        const SizedBox(height: 12),
        Caption(
          state.lunchSaved
              ? 'Bạn đã ghi nhận 2 bữa. Tiếp tục nhé!'
              : 'Đã ghi nhận bữa sáng. Thêm bữa trưa nhé!',
        ),
      ],
    );
  }
}

class _EnergyCard extends StatelessWidget {
  const _EnergyCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final goal = state.plan.kcal;
    final progress = (state.consumed / goal).clamp(0.0, 1.0);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THỨ NĂM, 29 THÁNG 10',
                      style: TextStyle(
                        fontSize: 10.5,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tiến độ năng lượng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              PillBadge(label: 'HOÀN THÀNH ${(progress * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 132,
                height: 132,
                child: CustomPaint(
                  painter: _RingPainter(progress),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatNumber(state.consumed),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const Text(
                          'kcal',
                          style: TextStyle(fontSize: 11, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _EnergyRow('Đã tiêu thụ', '${formatNumber(state.consumed)} kcal'),
                    _EnergyRow('Còn lại', '${formatNumber(state.remaining)} kcal'),
                    _EnergyRow(
                      'Đốt cháy',
                      '${state.activityKcal} kcal',
                      valueColor: AppColors.bright,
                    ),
                    _EnergyRow('Mục tiêu', '${formatNumber(goal)} kcal'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EnergyRow extends StatelessWidget {
  const _EnergyRow(this.label, this.value, {this.valueColor = AppColors.ink});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13.5, color: AppColors.muted),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);

    canvas.drawArc(
      arcRect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = AppColors.chip
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    if (progress <= 0) return;
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: sweep,
          colors: const [AppColors.ring, AppColors.bright],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard({required this.current, required this.onAdd});

  final int current;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final left = AppState.waterGoal - current;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Nước uống',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                '${formatNumber(current)} / '
                '${formatNumber(AppState.waterGoal)} ml',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppProgressBar(
            value: current / AppState.waterGoal,
            color: AppColors.primary,
            background: AppColors.chip,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  left > 0 ? 'Còn ${formatNumber(left)} ml' : 'Đã đạt mục tiêu',
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                ),
              ),
              TextButton(
                onPressed: onAdd,
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                child: const Text(
                  '+  Thêm 250 ml',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
