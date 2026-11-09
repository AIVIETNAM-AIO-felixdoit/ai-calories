import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';
import 'history_screen.dart';
import 'main_shell.dart';
import 'profile_screen.dart';
import 'scan_screen.dart';
import 'water_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ListView(
        padding: EdgeInsets.only(bottom: bottom + 20),
        children: [
          _Hero(state: state),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _WaterTile(
                      current: state.waterMl,
                      onAdd: () {
                        state.addWater();
                        pushScreen(context, const WaterScreen());
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _ActivityTile(
                      kcal: state.activityKcal,
                      onTap: () => state.selectTab(tabActivity),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 14),
            child: Row(
              children: [
                const Expanded(child: SectionTitle('Bữa ăn hôm nay')),
                GestureDetector(
                  onTap: () => pushScreen(context, const HistoryScreen()),
                  child: const Text(
                    'Lịch sử ›',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bright,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 196,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              children: [
                const _MealCard(
                  slot: 'Bữa sáng · 07:30',
                  title: 'Phở bò',
                  kcal: AppState.breakfastKcal,
                ),
                const SizedBox(width: 12),
                if (state.lunchSaved)
                  _MealCard(
                    slot: 'Bữa trưa · 12:30',
                    title: 'Cơm gà & rau xanh',
                    kcal: AppState.lunchKcal,
                    image: foodImage,
                    onTap: () => pushScreen(context, const DetailScreen()),
                  )
                else
                  _AddMealCard(
                    slot: 'Bữa trưa',
                    onTap: () => pushScreen(context, const ScanScreen()),
                  ),
                const SizedBox(width: 12),
                _AddMealCard(
                  slot: 'Bữa tối',
                  onTap: () => pushScreen(context, const ScanScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final goal = state.plan.kcal;
    final progress = (state.consumed / goal).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.fromLTRB(
        22,
        MediaQuery.paddingOf(context).top + 14,
        22,
        26,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17513D), AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'G',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chào Giang,',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Hôm nay, mình ăn uống cân bằng nhé.',
                      style: TextStyle(fontSize: 12.5, color: Color(0xB3FFFFFF)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => pushScreen(
                  context,
                  const ProfileScreen(fromSettings: true),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0x1FFFFFFF),
                ),
                icon: const Icon(Icons.tune_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _WeekStrip(onTap: () => pushScreen(context, const HistoryScreen())),
          const SizedBox(height: 22),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => CustomPaint(
              painter: _RingPainter(value),
              child: child,
            ),
            child: SizedBox(
              width: 216,
              height: 216,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatNumber(state.remaining),
                    style: const TextStyle(
                      fontSize: 52,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'kcal còn lại',
                    style: TextStyle(fontSize: 13.5, color: AppColors.lime),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _HeroStat('Đã nạp', formatNumber(state.consumed)),
              _HeroStat('Mục tiêu', formatNumber(goal)),
              _HeroStat('Đốt cháy', '${state.activityKcal}'),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              _MacroBar('Đạm', '45g', 0.35, AppColors.protein),
              SizedBox(width: 14),
              _MacroBar('Tinh bột', '120g', 0.46, AppColors.lime),
              SizedBox(width: 14),
              _MacroBar('Béo', '35g', 0.58, AppColors.fat),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.onTap});

  final VoidCallback onTap;

  static const _days = [
    ('T6', 23),
    ('T7', 24),
    ('CN', 25),
    ('T2', 26),
    ('T3', 27),
    ('T4', 28),
    ('T5', 29),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          for (final (weekday, day) in _days)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: day == 29 ? AppColors.lime : const Color(0x14FFFFFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      weekday,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: day == 29
                            ? AppColors.ink
                            : const Color(0x99FFFFFF),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: day == 29 ? AppColors.ink : Colors.white,
                      ),
                    ),
                  ],
                ),
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
    const stroke = 20.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);

    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = const Color(0x1FFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    if (progress <= 0) return;

    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..color = const Color(0x66C6F24E)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..color = AppColors.lime
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _HeroStat extends StatelessWidget {
  const _HeroStat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0x99FFFFFF)),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar(this.label, this.value, this.progress, this.color);

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: Color(0xB3FFFFFF)),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppProgressBar(
            value: progress,
            color: color,
            background: const Color(0x26FFFFFF),
          ),
        ],
      ),
    );
  }
}

class _WaterTile extends StatelessWidget {
  const _WaterTile({required this.current, required this.onAdd});

  final int current;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final level = (current / AppState.waterGoal).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: ColoredBox(
        color: AppColors.water,
        child: Stack(
          children: [
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: level,
                child: const ColoredBox(color: Color(0xFFA9DCF7)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.water_drop_rounded,
                    size: 24,
                    color: AppColors.waterDeep,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${formatNumber(current)} ml',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    'trên ${formatNumber(AppState.waterGoal)} ml',
                    style: const TextStyle(fontSize: 12, color: AppColors.ink),
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: AppColors.surface,
                    shape: const StadiumBorder(),
                    child: InkWell(
                      customBorder: const StadiumBorder(),
                      onTap: onAdd,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Text(
                          '+ 250 ml',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
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
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.kcal, required this.onTap});

  final int kcal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFE3D8),
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                size: 24,
                color: AppColors.highlight,
              ),
              const SizedBox(height: 10),
              Text(
                '$kcal kcal',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Text(
                'đã đốt hôm nay',
                style: TextStyle(fontSize: 12, color: AppColors.ink),
              ),
              const Spacer(),
              const Text(
                '6.420 bước',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.slot,
    required this.title,
    required this.kcal,
    this.image,
    this.onTap,
  });

  final String slot;
  final String title;
  final int kcal;
  final String? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: SizedBox(
          width: 158,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image.asset(image!, fit: BoxFit.cover)
              else
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFB86B), AppColors.highlight],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment(0, -0.35),
                    child: Icon(
                      Icons.ramen_dining_rounded,
                      size: 58,
                      color: Color(0xE6FFFFFF),
                    ),
                  ),
                ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xB3000000)],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: PillBadge(
                  label: '$kcal kcal',
                  color: AppColors.lime,
                  textColor: AppColors.ink,
                ),
              ),
              Positioned(
                left: 14,
                right: 12,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      slot,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xCCFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddMealCard extends StatelessWidget {
  const _AddMealCard({required this.slot, required this.onTap});

  final String slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.chip,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: SizedBox(
          width: 158,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.lime),
              ),
              const SizedBox(height: 12),
              Text(
                slot,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Text(
                'Chụp để ghi',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
