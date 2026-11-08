import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'export_screen.dart';
import 'pending_screen.dart';
import 'pt_screen.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  bool _photo = true;
  bool _nutrition = true;
  bool _note = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Chia sẻ bữa ăn',
          subtitle: 'Gửi thông tin bạn muốn, tới người bạn chọn.',
        ),
        const SizedBox(height: 18),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                foodImage,
                height: 132,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Cơm gà & rau xanh',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        PillBadge(label: '650 kcal', color: AppColors.chip),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '29/10 · Bữa trưa',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    SizedBox(height: 12),
                    MealMacros(),
                    SizedBox(height: 10),
                    Text(
                      'Ước tính theo khẩu phần đã xác nhận.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NỘI DUNG CHIA SẺ',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),
              _ShareOption(
                label: 'Ảnh bữa ăn',
                checked: _photo,
                onTap: () => setState(() => _photo = !_photo),
              ),
              const Divider(height: 1, color: AppColors.chip),
              _ShareOption(
                label: 'Thành phần & dinh dưỡng',
                checked: _nutrition,
                onTap: () => setState(() => _nutrition = !_nutrition),
              ),
              const Divider(height: 1, color: AppColors.chip),
              _ShareOption(
                label: 'Thêm ghi chú cá nhân',
                checked: _note,
                onTap: () => setState(() => _note = !_note),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: AppColors.bright),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bạn được xem lại nội dung trước khi chia sẻ.',
                        style: TextStyle(fontSize: 11.5, color: AppColors.bright),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AccentButton(
          label: 'Gửi cho PT đã kết nối',
          onPressed: () => pushScreen(
            context,
            state.ptInvited ? const PendingScreen() : const PtScreen(),
          ),
        ),
        const SizedBox(height: 12),
        TertiaryButton(
          label: 'Xuất ảnh kết quả',
          onPressed: () => pushScreen(context, const ExportScreen()),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Caption(
            'Không tự động truyền dữ liệu. Chỉ chia sẻ khi bạn xác nhận.',
          ),
        ),
      ],
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: checked ? AppColors.check : Colors.transparent,
                border: checked ? null : Border.all(color: AppColors.border, width: 2),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: checked ? FontWeight.w600 : FontWeight.w400,
                color: checked ? AppColors.ink : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
