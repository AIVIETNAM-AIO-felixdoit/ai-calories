import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCamera,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCamera;

  static const _items = <_NavItem>[
    _NavItem('Trang chủ', Icons.home_rounded),
    _NavItem('Vận động', Icons.directions_run_rounded),
    _NavItem('Tiến độ', Icons.bar_chart_rounded),
    _NavItem('Khám phá', Icons.menu_book_rounded),
  ];

  Widget _tab(int index) {
    final item = _items[index];
    final selected = index == currentIndex;
    final color = selected ? AppColors.lime : const Color(0x99FFFFFF);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 16,
            right: 16,
            bottom: 10,
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D0F3D2E),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _tab(0),
                  _tab(1),
                  const SizedBox(width: 72),
                  _tab(2),
                  _tab(3),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              key: const ValueKey('camera-button'),
              onTap: onCamera,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66A9E02C),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  color: AppColors.ink,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}
