import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Ảnh kết quả của bạn',
          subtitle: 'Bản xem trước trước khi xuất.',
        ),
        const SizedBox(height: 18),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.bright,
                padding: const EdgeInsets.fromLTRB(18, 14, 12, 14),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'AI CALORIES',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    PillBadge(
                      label: 'Bữa trưa · 29/10/2026',
                      color: Color(0x33FFFFFF),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Image.asset(
                foodImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cơm gà & rau xanh',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '650 kcal',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppColors.bright,
                      ),
                    ),
                    SizedBox(height: 10),
                    MealMacros(carbLabel: 'CARB'),
                    SizedBox(height: 14),
                    Text(
                      '29/10/2026 · Bữa trưa\nƯớc tính theo khẩu phần đã xác nhận',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.bright),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Prototype minh họa ảnh xuất. Không tự gửi dữ liệu.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.bright),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AccentButton(
          label: 'Quay lại bữa ăn',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
