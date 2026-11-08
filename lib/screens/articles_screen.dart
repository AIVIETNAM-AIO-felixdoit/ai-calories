import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'article_screen.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  static const _filters = ['Tất cả', 'Giảm cân', 'Thực đơn'];
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final saved = AppScope.of(context).articleSaved;

    return AppScreen(
      topBar: const AppTopBar(showBack: false, actionLabel: 'HỒ SƠ ›'),
      children: [
        const ScreenHeader(
          title: 'Khỏe hơn mỗi ngày',
          subtitle: 'Kiến thức nhỏ, thay đổi lớn.',
        ),
        const SizedBox(height: 22),
        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tìm bài viết',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              TextField(
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Tìm thực đơn, thói quen…',
                  hintStyle: TextStyle(color: AppColors.ink),
                  contentPadding: EdgeInsets.only(top: 8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (var i = 0; i < _filters.length; i++) ...[
              PillBadge(
                label: _filters[i],
                color: i == _filter ? AppColors.soft : Colors.transparent,
                textColor: i == _filter ? AppColors.primary : AppColors.muted,
                onTap: () => setState(() => _filter = i),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 16),
        const FoodImage(height: 190),
        const SizedBox(height: 16),
        Row(
          children: [
            const PillBadge(
              label: 'DÀNH CHO BẠN',
              color: Colors.transparent,
              textColor: AppColors.muted,
            ),
            if (saved) ...[
              const SizedBox(width: 8),
              const PillBadge(label: '✓ ĐÃ LƯU'),
            ],
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Ăn cơm Việt, vẫn cân bằng',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        const Text(
          'Một đĩa cơm quen thuộc có thể là khởi đầu của thói quen tốt.',
          style: TextStyle(fontSize: 14, color: AppColors.muted, height: 1.5),
        ),
        const SizedBox(height: 20),
        AccentButton(
          label: 'Đọc bài viết · 4 phút',
          onPressed: () => pushScreen(context, const ArticleScreen()),
        ),
      ],
    );
  }
}
