import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'goal_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.fromSettings = false});

  /// Mở từ nút "THIẾT LẬP" thay vì từ màn chào.
  final bool fromSettings;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Bắt đầu từ bạn',
          subtitle: 'Một vài thông tin để tạo kế hoạch phù hợp.',
        ),
        const StepBadge('BƯỚC 1 / 3'),
        const ValueCard(label: 'Chiều cao', value: '172 cm'),
        const ValueCard(label: 'Cân nặng hiện tại', value: '72 kg'),
        const ValueCard(label: 'Tuổi · Giới tính sinh học', value: '21 tuổi · Nam'),
        const ValueCard(
          label: 'Mức vận động thường ngày',
          value: 'Vừa phải · (3–4 buổi/tuần)',
        ),
        const Caption(
          'Thông tin giúp ước tính nhu cầu năng lượng. '
          'Bạn có thể thay đổi bất cứ lúc nào.',
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Tiếp tục  →',
          onPressed: () => pushScreen(context, const GoalScreen()),
        ),
      ],
    );
  }
}
