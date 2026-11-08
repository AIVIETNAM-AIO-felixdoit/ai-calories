import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'confirm_screen.dart';
import 'share_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Chi tiết bữa ăn',
          subtitle: 'Bữa trưa · 29/10/2026 · 12:30',
        ),
        const SizedBox(height: 20),
        const FoodImage(height: 190),
        const SizedBox(height: 22),
        const Text(
          'Cơm gà & rau xanh',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '650 kcal',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Ước tính theo khẩu phần đã xác nhận',
                style: TextStyle(fontSize: 12, color: AppColors.primary),
              ),
              SizedBox(height: 10),
              MealMacros(labelOnTop: false),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Đã xác nhận thành phần • Có thể chỉnh sửa',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        if (state.lunchSaved)
          const AppCard(
            color: AppColors.soft,
            child: Text(
              '✓  Đã lưu vào nhật ký',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          )
        else
          AccentButton(
            label: 'Lưu vào nhật ký',
            onPressed: () {
              state.saveLunch();
              showToast(context, 'Đã lưu bữa trưa vào nhật ký');
              popToRoot(context);
            },
          ),
        const SizedBox(height: 12),
        SecondaryButton(
          label: 'Xuất / gửi kết quả',
          onPressed: () => pushScreen(context, const ShareScreen()),
        ),
        const SizedBox(height: 12),
        TertiaryButton(
          label: 'Sửa thành phần',
          onPressed: () => pushScreen(context, const ConfirmScreen()),
        ),
      ],
    );
  }
}
