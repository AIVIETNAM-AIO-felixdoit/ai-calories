import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'saved_screen.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return AppScreen(
      children: [
        const Text(
          'Ăn cơm Việt,\nvẫn cân bằng',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.35),
        ),
        const SizedBox(height: 14),
        const Text(
          'KIẾN THỨC CƠ BẢN  ·  4 PHÚT ĐỌC',
          style: TextStyle(fontSize: 12.5, color: AppColors.muted),
        ),
        const SizedBox(height: 18),
        const FoodImage(height: 210),
        const SizedBox(height: 24),
        const Text(
          'Bắt đầu từ bữa ăn quen thuộc',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        const Text(
          'Không cần thay toàn bộ thực đơn trong một ngày. Hãy bắt đầu bằng '
          'việc hiểu những thành phần đang có trong đĩa cơm của bạn.',
          style: TextStyle(fontSize: 14.5, color: AppColors.muted, height: 1.6),
        ),
        const SizedBox(height: 20),
        const AppCard(
          color: AppColors.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '01   Nhìn từng thành phần',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text(
                'Ghi nhận cơm, thịt, rau và cả phần dầu hoặc sốt. Chỉnh lại '
                'khẩu phần nếu kết quả nhận diện chưa phù hợp.',
                style: TextStyle(fontSize: 13, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '02   Theo dõi để hiểu mình',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const Text(
          'Nhật ký bữa ăn giúp bạn nhìn lại thói quen qua từng ngày, '
          'thay vì chỉ nhìn một bữa.',
          style: TextStyle(fontSize: 14.5, color: AppColors.muted, height: 1.6),
        ),
        const SizedBox(height: 28),
        if (state.articleSaved)
          SecondaryButton(
            label: '✓ Đã lưu · bỏ lưu',
            onPressed: () => state.setArticleSaved(false),
          )
        else
          PrimaryButton(
            label: 'Lưu bài viết',
            onPressed: () {
              state.setArticleSaved(true);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (_) => const SavedScreen()),
              );
            },
          ),
      ],
    );
  }
}
