import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'main_shell.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Lời mời đã sẵn sàng',
          subtitle: 'Trạng thái minh họa · chưa gửi lời mời thật.',
        ),
        const SizedBox(height: 24),
        const AppCard(
          color: AppColors.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đang chờ PT chấp nhận',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'PT chưa có quyền xem dữ liệu của bạn.',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Nội dung được chia sẻ khi kết nối'),
        const SizedBox(height: 16),
        const AppCard(
          child: Text(
            'Nhật ký ăn uống\nTiến độ cân nặng\nLịch sử vận động',
            style: TextStyle(fontSize: 15.5, height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          label: 'Quay về Hôm nay',
          onPressed: () => backToTab(context, tabHome),
        ),
        const SizedBox(height: 16),
        SecondaryButton(
          label: 'Hủy lời mời',
          onPressed: () {
            AppScope.read(context).setPtInvited(false);
            showToast(context, 'Đã hủy lời mời PT');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
