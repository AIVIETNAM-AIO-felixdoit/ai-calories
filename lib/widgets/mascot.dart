import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum MascotMood { happy, wave, cheer, think, sleepy }

/// Bé Gạo: hạt gạo có mầm lá, vẽ bằng code nên nét ở mọi kích thước.
class Mascot extends StatefulWidget {
  const Mascot({super.key, this.mood = MascotMood.happy, this.size = 96});

  /// Tắt trong test, vì animation lặp vô hạn làm pumpAndSettle không dừng.
  static bool animate = true;

  final MascotMood mood;
  final double size;

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  @override
  void initState() {
    super.initState();
    if (Mascot.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.2,
      child: CustomPaint(
        painter: _MascotPainter(widget.mood, _controller),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter(this.mood, this.time) : super(repaint: time);

  final MascotMood mood;
  final Animation<double> time;

  static const _outline = AppColors.ink;
  static const _body = Color(0xFFFFFDF4);
  static const _shade = Color(0xFFFFEBC2);

  Paint get _stroke => Paint()
    ..color = _outline
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _fill(Color color) => Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final wave = math.sin(t * 2 * math.pi);
    final bob = wave * (mood == MascotMood.cheer ? 3.5 : 1.8);

    // Toạ độ vẽ theo khung 100 x 120.
    canvas.scale(size.width / 100, size.height / 120);

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 115), width: 54 - bob, height: 7),
      _fill(AppColors.ink.withValues(alpha: 0.13)),
    );

    canvas.save();
    canvas.translate(0, bob - 2);
    _drawFeet(canvas);
    _drawArms(canvas, t);
    _drawBody(canvas);
    _drawSprout(canvas, wave);
    _drawFace(canvas, t);
    canvas.restore();
  }

  void _drawFeet(Canvas canvas) {
    for (final x in const [38.0, 62.0]) {
      final rect = Rect.fromCenter(center: Offset(x, 110), width: 15, height: 9);
      canvas.drawOval(rect, _fill(_shade));
      canvas.drawOval(rect, _stroke);
    }
  }

  void _drawArm(Canvas canvas, Offset from, Offset control, Offset to) {
    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);
    canvas.drawPath(path, _stroke..strokeWidth = 9);
    canvas.drawPath(
      path,
      Paint()
        ..color = _body
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.6,
    );
  }

  void _drawArms(Canvas canvas, double t) {
    const leftShoulder = Offset(17, 72);
    const rightShoulder = Offset(83, 72);
    switch (mood) {
      case MascotMood.wave:
        final swing = math.sin(t * 2 * math.pi * 3) * 6;
        _drawArm(canvas, leftShoulder, const Offset(7, 84), const Offset(10, 92));
        _drawArm(
          canvas,
          rightShoulder,
          const Offset(95, 66),
          Offset(93 + swing, 48),
        );
      case MascotMood.cheer:
        final lift = math.sin(t * 2 * math.pi * 2) * 3;
        _drawArm(canvas, leftShoulder, const Offset(6, 62), Offset(9, 46 + lift));
        _drawArm(canvas, rightShoulder, const Offset(94, 62), Offset(91, 46 + lift));
      case MascotMood.think:
        _drawArm(canvas, leftShoulder, const Offset(7, 84), const Offset(10, 92));
        _drawArm(canvas, rightShoulder, const Offset(94, 92), const Offset(72, 92));
      case MascotMood.happy:
      case MascotMood.sleepy:
        _drawArm(canvas, leftShoulder, const Offset(7, 84), const Offset(10, 92));
        _drawArm(canvas, rightShoulder, const Offset(93, 84), const Offset(90, 92));
    }
  }

  void _drawBody(Canvas canvas) {
    final path = Path()
      ..moveTo(50, 24)
      ..cubicTo(72, 24, 86, 52, 86, 76)
      ..cubicTo(86, 98, 70, 112, 50, 112)
      ..cubicTo(30, 112, 14, 98, 14, 76)
      ..cubicTo(14, 52, 28, 24, 50, 24)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_body, _body, _shade],
          stops: [0, 0.55, 1],
        ).createShader(const Rect.fromLTWH(14, 24, 72, 88)),
    );
    canvas.drawPath(path, _stroke);
  }

  void _drawSprout(Canvas canvas, double wave) {
    canvas.save();
    canvas.translate(50, 25);
    canvas.rotate(wave * 0.07);
    canvas.drawLine(Offset.zero, const Offset(0, -9), _stroke);

    final left = Path()
      ..moveTo(0, -9)
      ..quadraticBezierTo(-6, -24, -24, -21)
      ..quadraticBezierTo(-20, -6, 0, -9)
      ..close();
    final right = Path()
      ..moveTo(0, -9)
      ..quadraticBezierTo(5, -23, 21, -19)
      ..quadraticBezierTo(18, -5, 0, -9)
      ..close();
    canvas.drawPath(left, _fill(AppColors.bright));
    canvas.drawPath(left, _stroke);
    canvas.drawPath(right, _fill(const Color(0xFF7BDDB3)));
    canvas.drawPath(right, _stroke);
    canvas.restore();
  }

  void _drawFace(Canvas canvas, double t) {
    final cheek = _fill(const Color(0xFFFFA99A).withValues(alpha: 0.75));
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(27, 79), width: 13, height: 8),
      cheek,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(73, 79), width: 13, height: 8),
      cheek,
    );

    final blinking = t > 0.93 && t < 0.98;
    for (final x in const [37.0, 63.0]) {
      _drawEye(canvas, Offset(x, 68), blinking);
    }
    _drawMouth(canvas);
  }

  void _drawEye(Canvas canvas, Offset c, bool blinking) {
    final curve = _stroke..strokeWidth = 3.2;
    if (mood == MascotMood.cheer) {
      canvas.drawPath(
        Path()
          ..moveTo(c.dx - 6, c.dy + 2)
          ..quadraticBezierTo(c.dx, c.dy - 8, c.dx + 6, c.dy + 2),
        curve,
      );
      return;
    }
    if (mood == MascotMood.sleepy || blinking) {
      canvas.drawPath(
        Path()
          ..moveTo(c.dx - 6, c.dy - 1)
          ..quadraticBezierTo(c.dx, c.dy + 6, c.dx + 6, c.dy - 1),
        curve,
      );
      return;
    }
    final look = mood == MascotMood.think ? const Offset(1.5, -2) : Offset.zero;
    canvas.drawCircle(c, 6.5, _fill(_outline));
    canvas.drawCircle(c + const Offset(2, -2.4) + look, 2.3, _fill(Colors.white));
    canvas.drawCircle(c + const Offset(-2, 2.2), 1.1, _fill(Colors.white));
  }

  void _drawMouth(Canvas canvas) {
    switch (mood) {
      case MascotMood.cheer:
        final mouth = Path()
          ..moveTo(41, 79)
          ..quadraticBezierTo(50, 81, 59, 79)
          ..quadraticBezierTo(57, 95, 50, 95)
          ..quadraticBezierTo(43, 95, 41, 79)
          ..close();
        canvas.drawPath(mouth, _fill(const Color(0xFFE5604D)));
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(50, 91), width: 10, height: 6),
          _fill(const Color(0xFFFFA99A)),
        );
        canvas.drawPath(mouth, _stroke..strokeWidth = 2.6);
      case MascotMood.think:
        canvas.drawPath(
          Path()
            ..moveTo(45, 84)
            ..quadraticBezierTo(50, 81, 55, 84),
          _stroke..strokeWidth = 2.8,
        );
      case MascotMood.sleepy:
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(50, 84), width: 6, height: 7),
          _stroke..strokeWidth = 2.6,
        );
      case MascotMood.happy:
      case MascotMood.wave:
        canvas.drawPath(
          Path()
            ..moveTo(43, 80)
            ..quadraticBezierTo(50, 90, 57, 80),
          _stroke..strokeWidth = 3,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.mood != mood;
}

/// Bé Gạo kèm bong bóng lời thoại.
class MascotBubble extends StatelessWidget {
  const MascotBubble({
    super.key,
    required this.text,
    this.mood = MascotMood.happy,
    this.size = 64,
  });

  final String text;
  final MascotMood mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Mascot(mood: mood, size: size),
        const SizedBox(width: 6),
        CustomPaint(
          size: const Size(9, 16),
          painter: const _BubbleTail(),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BubbleTail extends CustomPainter {
  const _BubbleTail();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width, 0)
        ..lineTo(0, size.height / 2)
        ..lineTo(size.width, size.height)
        ..close(),
      Paint()..color = AppColors.surface,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
