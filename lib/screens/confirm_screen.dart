import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final _portions = <_Portion>[
    _Portion('Cơm trắng', 200, editable: false),
    _Portion('Gà nướng', 150),
    _Portion('Rau & dưa leo', 100),
    _Portion('Sốt / dầu ăn', 10),
  ];

  Future<void> _edit(_Portion portion) async {
    final controller = TextEditingController(text: '${portion.grams}');
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(portion.name),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'g'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(int.tryParse(controller.text)),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result > 0) {
      setState(() => portion.grams = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Kiểm tra bữa ăn',
          subtitle: 'AI gợi ý món. Bạn xác nhận giúp mình nhé.',
        ),
        const SizedBox(height: 20),
        const FoodImage(height: 190),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: PillBadge(label: 'AI NHẬN DIỆN'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Cơm gà & rau xanh',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        AppCard(
          border: true,
          padding: const EdgeInsets.fromLTRB(18, 12, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final p in _portions)
                _PortionRow(
                  portion: p,
                  onEdit: p.editable ? () => _edit(p) : null,
                ),
              TextButton(
                onPressed: () => showToast(context, 'Bản demo: chưa thêm được thành phần mới'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.primary,
                ),
                child: const Text(
                  '+  Thêm thành phần',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Caption(
          'Khối lượng và dầu/sốt có thể khác thực tế. '
          'Hãy kiểm tra trước khi lưu.',
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Xác nhận · xem dinh dưỡng',
          onPressed: () => pushScreen(context, const DetailScreen()),
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          label: 'Chụp lại',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _Portion {
  _Portion(this.name, this.grams, {this.editable = true});

  final String name;
  int grams;
  final bool editable;
}

class _PortionRow extends StatelessWidget {
  const _PortionRow({required this.portion, this.onEdit});

  final _Portion portion;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                portion.name,
                style: const TextStyle(fontSize: 15, color: AppColors.muted),
              ),
            ),
            Text(
              '${portion.grams} g',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 28,
              child: onEdit == null
                  ? null
                  : const Icon(Icons.edit_outlined, size: 16, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
