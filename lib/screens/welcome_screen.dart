import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'main_shell.dart';
import 'profile_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(foodImage, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x660A2C21),
                          Color(0x000A2C21),
                          AppColors.primaryDark,
                        ],
                        stops: [0, 0.4, 1],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 120,
                    left: 22,
                    child: _GlassTag(
                      icon: Icons.local_fire_department_rounded,
                      text: '650 kcal',
                    ),
                  ),
                  const Positioned(
                    top: 200,
                    right: 22,
                    child: _GlassTag(
                      icon: Icons.auto_awesome_rounded,
                      text: 'Cơm gà & rau xanh',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, bottom + 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI CALORIES',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                      color: AppColors.lime,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ăn uống có mục tiêu.\nTheo dõi dễ dàng.',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chụp một tấm ảnh, biết ngay bữa ăn của bạn. '
                    'Chỉ chia sẻ với PT khi bạn cho phép.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xB3FFFFFF),
                    ),
                  ),
                  const SizedBox(height: 22),
                  AccentButton(
                    label: 'Bắt đầu thiết lập mục tiêu',
                    onPressed: () => pushScreen(context, const ProfileScreen()),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton(
                      onPressed: () => openMainShell(context),
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text(
                        'Khám phá trang chủ',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
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

class _GlassTag extends StatelessWidget {
  const _GlassTag({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.highlight),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
