import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'main_shell.dart';
import 'profile_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      topBar: null,
      children: [
        const SizedBox(height: 16),
        const Text(
          'AI CALORIES',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Ăn uống có mục tiêu.\nTheo dõi dễ dàng.',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.4),
        ),
        const SizedBox(height: 16),
        const Text(
          'Từ bữa ăn hôm nay đến thói quen mỗi ngày.',
          style: TextStyle(fontSize: 14, color: AppColors.muted),
        ),
        const SizedBox(height: 28),
        const AppCard(
          border: true,
          child: Column(
            children: [
              _StepItem(
                number: '01',
                title: 'Thiết lập mục tiêu',
                description:
                    'Nhập thông tin cơ thể và chọn\ntăng cân, giảm cân hoặc ăn lành mạnh.',
              ),
              _StepItem(
                number: '02',
                title: 'Ghi lại bữa ăn',
                description:
                    'Chụp ảnh → kiểm tra khẩu phần\n→ lưu lượng dinh dưỡng ước tính.',
              ),
              _StepItem(
                number: '03',
                title: 'Theo dõi mỗi ngày',
                description:
                    'Xem năng lượng, nước và vận động.\nNhìn lại tiến độ, chia sẻ với PT.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const AppCard(
          color: AppColors.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bạn luôn chủ động',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Chỉ chia sẻ với PT khi bạn cho phép.',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        PrimaryButton(
          label: 'Bắt đầu thiết lập mục tiêu',
          leading: true,
          onPressed: () => pushScreen(context, const ProfileScreen()),
        ),
        const SizedBox(height: 12),
        OutlineButtonWhite(
          label: 'Khám phá trang chủ',
          leading: true,
          onPressed: () => openMainShell(context),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.soft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
