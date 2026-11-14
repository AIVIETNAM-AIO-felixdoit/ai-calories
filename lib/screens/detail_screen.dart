import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'share_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.meal});

  final LoggedMeal meal;

  /// null nghĩa là thiếu dữ liệu: không hiển thị thành 0.
  static String _amount(Nutrient? n) {
    final value = n?.amount;
    if (value == null) return '—';
    final text = value >= 10 ? value.round().toString() : value.toStringAsFixed(1);
    return n!.complete ? '$text ${n.unit}' : '≥$text ${n.unit}';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final saved = state.isLogged(meal);
    final nutrition = meal.nutrition;
    final energy = nutrition.energy;
    final incomplete = nutrition.nutrients.values
        .where((n) => !n.complete)
        .map((n) => n.name)
        .toList();

    return AppScreen(
      children: [
        ScreenHeader(
          title: 'Chi tiết bữa ăn',
          subtitle: 'Hôm nay · ${meal.time} · ${nutrition.totalGrams.round()} g',
        ),
        const SizedBox(height: 20),
        FoodImage(height: 190, bytes: meal.photo),
        const SizedBox(height: 22),
        Text(
          meal.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.kcal == null ? 'Chưa đủ dữ liệu kcal' : '${formatNumber(meal.kcal!)} kcal',
                style: TextStyle(
                  fontSize: meal.kcal == null ? 24 : 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                energy != null && !energy.complete
                    ? 'Thiếu dữ liệu năng lượng của một số thành phần'
                    : 'Ước tính theo khẩu phần đã xác nhận',
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
              const SizedBox(height: 10),
              MealMacros(
                labelOnTop: false,
                protein: _amount(nutrition.protein),
                carbs: _amount(nutrition.carbs),
                fat: _amount(nutrition.fat),
              ),
            ],
          ),
        ),
        if (incomplete.isNotEmpty) ...[
          const SizedBox(height: 14),
          Caption('Chưa đủ dữ liệu: ${incomplete.join(', ')}.'),
        ],
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
        if (saved)
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
              state.logMeal(meal);
              showToast(context, 'Đã lưu ${meal.title} vào nhật ký');
              popToRoot(context);
            },
          ),
        const SizedBox(height: 12),
        SecondaryButton(
          label: 'Xuất / gửi kết quả',
          onPressed: () => pushScreen(context, const ShareScreen()),
        ),
        if (!saved) ...[
          const SizedBox(height: 12),
          TertiaryButton(
            label: 'Sửa thành phần',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ],
    );
  }
}
