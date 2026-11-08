import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  // Bắt đầu từ số liệu trong thiết kế để bản demo trông giống thật.
  int _seconds = 24 * 60 + 8;
  bool _paused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_paused) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _clock {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _finish() {
    final now = TimeOfDay.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    AppScope.read(context).addRun(
      RunRecord('Hôm nay · $time', '3,2 km', _seconds ~/ 60, '7:30/km', 240),
    );
    showToast(context, 'Đã lưu buổi chạy');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        ScreenHeader(
          title: _paused ? 'Nghỉ một chút nhé' : 'Một vòng thật khỏe',
          subtitle: _paused
              ? 'Buổi chạy đang tạm dừng.'
              : 'Chạy bộ ngoài trời · bản xem trước',
        ),
        const SizedBox(height: 24),
        if (!_paused) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: const SizedBox(
              height: 270,
              width: double.infinity,
              child: CustomPaint(painter: _RouteMapPainter()),
            ),
          ),
          const SizedBox(height: 16),
        ],
        GreenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _clock,
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              if (_paused) ...[
                const Text(
                  '3,2 km  ·  240 kcal',
                  style: TextStyle(fontSize: 19, color: AppColors.accent),
                ),
                const SizedBox(height: 12),
                const Text(
                  'TẠM DỪNG',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                const Text(
                  'THỜI GIAN VẬN ĐỘNG',
                  style: TextStyle(fontSize: 11, color: AppColors.accent),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    _Stat('3,2 km'),
                    _Stat('240 kcal'),
                    _Stat('7:30/km'),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_paused) ...[
          PrimaryButton(
            label: 'Tiếp tục chạy',
            onPressed: () => setState(() => _paused = false),
          ),
          const SizedBox(height: 16),
          SecondaryButton(label: 'Kết thúc & lưu', onPressed: _finish),
        ] else ...[
          const Caption('Bản đồ lộ trình minh họa'),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Kết thúc & lưu buổi chạy', onPressed: _finish),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'Tạm dừng',
            onPressed: () => setState(() => _paused = true),
          ),
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Bản đồ minh hoạ: các ô phố, đường trắng và một vòng chạy.
class _RouteMapPainter extends CustomPainter {
  const _RouteMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.soft);

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 12;
    final lane = Paint()
      ..color = const Color(0xFFD9DED3)
      ..strokeWidth = 1.5;
    for (final x in [0.22 * w, 0.82 * w]) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), road);
      canvas.drawLine(Offset(x, 0), Offset(x, h), lane);
    }
    for (final y in [0.3 * h, 0.72 * h]) {
      canvas.drawLine(Offset(0, y), Offset(w, y), road);
      canvas.drawLine(Offset(0, y), Offset(w, y), lane);
    }

    final center = Offset(0.52 * w, 0.52 * h);
    final rect = Rect.fromCenter(center: center, width: 0.42 * w, height: 0.62 * h);
    final route = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -1.75, 2 * math.pi - 0.35, false, route);

    const startAngle = -1.75;
    final start = Offset(
      center.dx + rect.width / 2 * math.cos(startAngle),
      center.dy + rect.height / 2 * math.sin(startAngle),
    );
    canvas.drawCircle(start, 11, Paint()..color = Colors.white);
    canvas.drawCircle(start, 8, Paint()..color = AppColors.highlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
