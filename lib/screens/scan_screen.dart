import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'confirm_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  /// Giả lập AI nhận diện món ăn rồi chuyển sang màn kiểm tra.
  Future<void> _analyze(BuildContext context) async {
    final navigator = Navigator.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              CircularProgressIndicator(color: AppColors.bright),
              SizedBox(width: 20),
              Expanded(child: Text('AI đang nhận diện món ăn…')),
            ],
          ),
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    navigator.pop();
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const ConfirmScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      topBar: Row(
        children: [
          const Expanded(
            child: Text(
              'Ghi bữa ăn',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          ),
        ],
      ),
      children: [
        const Text(
          'BƯỚC 1 / 3',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        const ScreenHeader(
          title: 'Chụp ảnh bữa ăn',
          subtitle: 'Chụp rõ món ăn để dễ kiểm tra khẩu phần.',
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Text(
                'Ảnh món ăn sẽ hiển thị tại đây',
                style: TextStyle(fontSize: 13.5, color: AppColors.muted),
              ),
              const SizedBox(height: 14),
              Container(
                height: 196,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          label: '+  Chụp ảnh bữa ăn',
          onPressed: () => _analyze(context),
        ),
        const SizedBox(height: 12),
        _UploadButton(onPressed: () => _analyze(context)),
        const SizedBox(height: 20),
        for (final (i, step) in const [
          'Chụp ảnh bữa ăn',
          'Kiểm tra món ăn và sửa khẩu phần',
          'Xác nhận rồi lưu vào nhật ký',
        ].indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${i + 1}.',
                    style: const TextStyle(fontSize: 14, color: AppColors.muted),
                  ),
                ),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(fontSize: 14, color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        const AppCard(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(
            'Dinh dưỡng từ ảnh là số liệu ước tính.\n'
            'Bạn có thể chỉnh sửa trước khi lưu.',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.image_outlined, size: 20),
        label: const Text(
          'Tải ảnh từ thư viện',
          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
