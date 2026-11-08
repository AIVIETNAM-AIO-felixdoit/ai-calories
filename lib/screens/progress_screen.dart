import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'history_screen.dart';
import 'pending_screen.dart';
import 'pt_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _days = ['T6', 'T7', 'CN', 'T2', 'T3', 'T4', 'T5'];
  static const _values = [0.6, 0.83, 0.72, 0.9, 0.65, 0.8, 0.5];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return AppScreen(
      topBar: const AppTopBar(showBack: false, actionLabel: 'HỒ SƠ ›'),
      children: [
        const ScreenHeader(
          title: 'Nhìn lại để tiến lên',
          subtitle: 'Bạn đang xây một thói quen tốt.',
        ),
        const StepBadge('TUẦN NÀY · 23–29/10'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nhịp ăn uống của bạn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 132,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < _days.length; i++)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 24,
                              height: 110 * _values[i],
                              decoration: BoxDecoration(
                                color: i == _days.length - 1
                                    ? AppColors.highlight
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _days[i],
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const InfoRow('Đã nạp trong tuần', '13.850 kcal'),
              const InfoRow('Calo vận động', '1.840 kcal'),
              const InfoRow('Nạp trừ vận động', '12.010 kcal'),
              const SizedBox(height: 6),
              const Text(
                'Không phải mức thâm hụt: chưa trừ chuyển hóa nền và '
                'hoạt động thường ngày.',
                style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const GreenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '7 ngày liên tiếp',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Ghi nhận ít nhất 1 bữa mỗi ngày để giữ chuỗi.',
                style: TextStyle(fontSize: 12.5, color: AppColors.accent),
              ),
              SizedBox(height: 10),
              Text(
                '23 ✓   24 ✓   25 ✓   26 ✓   27 ✓   28 ✓   29 ✓',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LinkCard(
          title: 'Nhật ký của bạn',
          subtitle: 'Lịch sử bữa ăn · Theo từng ngày',
          onTap: () => pushScreen(context, const HistoryScreen()),
        ),
        const SizedBox(height: 12),
        LinkCard(
          title: 'Có PT cùng đồng hành',
          subtitle: state.ptInvited
              ? 'Đang chờ PT chấp nhận lời mời'
              : 'Chia sẻ tiến độ khi bạn cho phép',
          onTap: () => pushScreen(
            context,
            state.ptInvited ? const PendingScreen() : const PtScreen(),
          ),
        ),
      ],
    );
  }
}
