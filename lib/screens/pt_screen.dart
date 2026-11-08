import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'pending_screen.dart';

class PtScreen extends StatefulWidget {
  const PtScreen({super.key});

  @override
  State<PtScreen> createState() => _PtScreenState();
}

class _PtScreenState extends State<PtScreen> {
  final _phone = TextEditingController();
  bool _meals = true;
  bool _weight = true;
  bool _activity = true;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _invite() {
    AppScope.read(context).setPtInvited(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const PendingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Có PT cùng đồng hành',
          subtitle: 'Chia sẻ tiến độ, nhận hỗ trợ đúng lúc.',
        ),
        const SizedBox(height: 24),
        const GreenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cùng bạn, từng bước.',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'PT có thể xem nhật ký ăn uống, vận động và tiến độ '
                'khi bạn cho phép.',
                style: TextStyle(fontSize: 13, color: AppColors.accent, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Số điện thoại của PT',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Nhập số điện thoại',
                  hintStyle: TextStyle(color: AppColors.ink),
                  contentPadding: EdgeInsets.only(top: 8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Caption('Chỉ gửi lời mời. Quyền xem được mở sau khi PT chấp nhận.'),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bạn muốn chia sẻ gì?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              CheckLine(
                label: 'Nhật ký bữa ăn & dinh dưỡng',
                checked: _meals,
                onChanged: (v) => setState(() => _meals = v),
              ),
              CheckLine(
                label: 'Mục tiêu & tiến độ cân nặng',
                checked: _weight,
                onChanged: (v) => setState(() => _weight = v),
              ),
              CheckLine(
                label: 'Lịch sử vận động',
                checked: _activity,
                onChanged: (v) => setState(() => _activity = v),
              ),
              const SizedBox(height: 6),
              const Caption('Bạn có thể ngừng chia sẻ bất kỳ lúc nào.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Gửi lời mời PT', onPressed: _invite),
        const SizedBox(height: 16),
        SecondaryButton(
          label: 'Để sau · về trang chủ',
          onPressed: () => popToRoot(context),
        ),
      ],
    );
  }
}
