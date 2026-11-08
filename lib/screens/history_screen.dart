import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _today = 29;
  static const _loggedDays = {23, 24, 25, 26, 27, 28, 29};
  int _selected = _today;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final isToday = _selected == _today;

    return AppScreen(
      topBar: const AppTopBar(actionLabel: 'HỒ SƠ ›'),
      children: [
        const ScreenHeader(
          title: 'Nhật ký của bạn',
          subtitle: 'Nhìn lại từng bữa, từng ngày.',
        ),
        const StepBadge('THÁNG 10, 2026'),
        AppCard(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 14),
          child: Column(
            children: [
              _Calendar(
                selected: _selected,
                loggedDays: _loggedDays,
                onSelect: (day) => setState(() => _selected = day),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.muted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Có nhật ký   •   Đang xem ngày $_selected/10',
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isToday) ...[
          InfoRow('Hôm nay', '${formatNumber(state.consumed)} kcal nạp'),
          InfoRow('Vận động', '${state.activityKcal} kcal'),
        ] else
          InfoRow(
            'Ngày $_selected/10',
            _loggedDays.contains(_selected) ? 'Đã ghi nhận' : 'Chưa có nhật ký',
          ),
        const SizedBox(height: 24),
        const SectionTitle('Lịch sử chụp & bữa ăn'),
        const SizedBox(height: 14),
        if (!isToday)
          const Caption('Bản demo chỉ có dữ liệu chi tiết cho hôm nay (29/10).')
        else ...[
          if (state.lunchSaved) ...[
            MealTile(
              title: 'Cơm gà & rau xanh',
              subtitle: '12:30 · Đã xác nhận',
              onTap: () => pushScreen(context, const DetailScreen()),
            ),
            const SizedBox(height: 12),
          ],
          const MealTile(
            title: 'Phở bò',
            subtitle: '07:30 · Đã xác nhận',
            showImage: false,
          ),
        ],
      ],
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar({
    required this.selected,
    required this.loggedDays,
    required this.onSelect,
  });

  final int selected;
  final Set<int> loggedDays;
  final ValueChanged<int> onSelect;

  static const _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  // 1/10/2026 là thứ Năm, nên có 3 ô trống đầu tháng.
  static const _leading = 3;
  static const _daysInMonth = 31;

  @override
  Widget build(BuildContext context) {
    final cells = <int?>[
      for (var i = 0; i < _leading; i++) null,
      for (var d = 1; d <= _daysInMonth; d++) d,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return Column(
      children: [
        Row(
          children: [
            for (final w in _weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    w,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        for (var row = 0; row < cells.length ~/ 7; row++)
          Row(
            children: [
              for (final day in cells.sublist(row * 7, row * 7 + 7))
                Expanded(child: _dayCell(day)),
            ],
          ),
      ],
    );
  }

  Widget _dayCell(int? day) {
    if (day == null) return const SizedBox(height: 44);
    final isSelected = day == selected;
    final logged = loggedDays.contains(day);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: isSelected
            ? AppColors.primary
            : logged
                ? AppColors.soft
                : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onSelect(day),
          child: SizedBox(
            height: 40,
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
