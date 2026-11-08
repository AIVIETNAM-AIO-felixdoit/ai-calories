import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'article_screen.dart';
import 'main_shell.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Đã lưu bài viết',
          subtitle: 'Đọc lại khi bạn cần một chút cảm hứng.',
        ),
        const SizedBox(height: 24),
        const FoodImage(height: 240),
        const SizedBox(height: 20),
        const Text(
          'Ăn cơm Việt, vẫn cân bằng',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700, height: 1.35),
        ),
        const SizedBox(height: 14),
        const Align(
          alignment: Alignment.centerLeft,
          child: PillBadge(label: '✓ ĐÃ LƯU'),
        ),
        const SizedBox(height: 14),
        const Text(
          'Bài viết này nằm trong bộ sưu tập của bạn.',
          style: TextStyle(fontSize: 14, color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        AccentButton(
          label: 'Đọc tiếp',
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const ArticleScreen()),
          ),
        ),
        const SizedBox(height: 16),
        SecondaryButton(
          label: 'Về Khám phá',
          onPressed: () => backToTab(context, tabExplore),
        ),
      ],
    );
  }
}
