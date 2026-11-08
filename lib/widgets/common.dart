import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';
import '../theme/app_colors.dart';

const foodImage = 'assets/images/com_ga.jpg';

void pushScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
}

/// Quay về màn đầu tiên trong stack (MainShell).
void popToRoot(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String formatNumber(int value) {
  final text = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

/// Khung chung cho mọi màn: thanh trên + nội dung cuộn.
class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.children,
    this.topBar = const AppTopBar(),
  });

  final List<Widget> children;
  final Widget? topBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            if (topBar != null) ...[topBar!, const SizedBox(height: 28)],
            ...children,
          ],
        ),
      ),
    );
  }
}

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.showBack = true,
    this.actionLabel = 'THIẾT LẬP',
    this.onAction,
  });

  final bool showBack;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack) ...[
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.of(context).maybePop(),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.chevron_left, color: AppColors.ink, size: 26),
            ),
          ),
          const SizedBox(width: 4),
        ],
        const Text(
          'AI Calories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        PillBadge(
          label: actionLabel,
          onTap: onAction ??
              () => pushScreen(context, const ProfileScreen(fromSettings: true)),
        ),
      ],
    );
  }
}

class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.label,
    this.color = AppColors.soft,
    this.textColor = AppColors.primary,
    this.onTap,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.25,
            color: AppColors.ink,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14, color: AppColors.muted),
          ),
        ],
      ],
    );
  }
}

/// Nhãn bước kiểu "BƯỚC 1 / 3", căn trái.
class StepBadge extends StatelessWidget {
  const StepBadge(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: PillBadge(label: label),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool leading;

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: label,
      onPressed: onPressed,
      leading: leading,
      background: AppColors.primary,
      foreground: Colors.white,
    );
  }
}

/// Nút xanh tươi, dùng cho hành động nổi bật nhất của màn.
class AccentButton extends StatelessWidget {
  const AccentButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: label,
      onPressed: onPressed,
      leading: false,
      background: AppColors.bright,
      foreground: Colors.white,
    );
  }
}

/// Nút xám nhạt, dùng cho hành động phụ thứ ba.
class TertiaryButton extends StatelessWidget {
  const TertiaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: label,
      onPressed: onPressed,
      leading: false,
      background: AppColors.chip,
      foreground: AppColors.primary,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool leading;

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: label,
      onPressed: onPressed,
      leading: leading,
      background: AppColors.soft,
      foreground: AppColors.primary,
    );
  }
}

class OutlineButtonWhite extends StatelessWidget {
  const OutlineButtonWhite({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool leading;

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: label,
      onPressed: onPressed,
      leading: leading,
      background: AppColors.surface,
      foreground: AppColors.primary,
      border: true,
    );
  }
}

class _BaseButton extends StatelessWidget {
  const _BaseButton({
    required this.label,
    required this.onPressed,
    required this.leading,
    required this.background,
    required this.foreground,
    this.border = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool leading;
  final Color background;
  final Color foreground;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          alignment: leading ? Alignment.centerLeft : Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: border
                ? const BorderSide(color: AppColors.border)
                : BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color = AppColors.surface,
    this.padding = const EdgeInsets.all(18),
    this.border = false,
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final bool border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24);
    final isWhite = color == AppColors.surface;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        // Thẻ trắng trong thiết kế mới có bóng rất nhẹ thay cho nền khác màu.
        boxShadow: isWhite
            ? const [
                BoxShadow(
                  color: Color(0x14245D44),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: border
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: SizedBox(width: double.infinity, child: child),
          ),
        ),
      ),
    );
  }
}

/// Ô nhỏ hiển thị một chỉ số dinh dưỡng (đạm, tinh bột, béo…).
class MacroChip extends StatelessWidget {
  const MacroChip({
    super.key,
    required this.value,
    required this.label,
    this.labelOnTop = false,
    this.color = AppColors.chip,
  });

  final String value;
  final String label;
  final bool labelOnTop;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final valueText = Text(
      value,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    );
    final labelText = Text(
      label,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: AppColors.muted,
      ),
    );
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: labelOnTop
              ? [labelText, const SizedBox(height: 4), valueText]
              : [valueText, const SizedBox(height: 4), labelText],
        ),
      ),
    );
  }
}

/// Hàng 3 ô dinh dưỡng của bữa cơm gà, dùng ở chi tiết, chia sẻ, xuất ảnh.
class MealMacros extends StatelessWidget {
  const MealMacros({super.key, this.labelOnTop = true, this.carbLabel = 'TINH BỘT'});

  final bool labelOnTop;
  final String carbLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MacroChip(value: '42 g', label: labelOnTop ? 'ĐẠM' : 'Đạm', labelOnTop: labelOnTop),
        const SizedBox(width: 8),
        MacroChip(
          value: '74 g',
          label: labelOnTop ? carbLabel : 'Tinh bột',
          labelOnTop: labelOnTop,
        ),
        const SizedBox(width: 8),
        MacroChip(value: '21 g', label: labelOnTop ? 'BÉO' : 'Chất béo', labelOnTop: labelOnTop),
      ],
    );
  }
}

class GreenCard extends StatelessWidget {
  const GreenCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

/// Thẻ trắng có nhãn nhỏ và giá trị lớn (form thông tin).
class ValueCard extends StatelessWidget {
  const ValueCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: AppColors.muted),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
    );
  }
}

class Caption extends StatelessWidget {
  const Caption(this.text, {super.key, this.color = AppColors.muted});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 12.5, color: color, height: 1.5),
    );
  }
}

class FoodImage extends StatelessWidget {
  const FoodImage({super.key, this.height = 190, this.radius = 24});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        foodImage,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.background = const Color(0x59FFFFFF),
  });

  final double value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 6,
        backgroundColor: background,
        color: color,
      ),
    );
  }
}

/// Thẻ bữa ăn: ảnh nhỏ, tên, giờ, kcal.
class MealTile extends StatelessWidget {
  const MealTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.kcal,
    this.showImage = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final int? kcal;
  final bool showImage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: showImage
                ? Image.asset(foodImage, width: 60, height: 60, fit: BoxFit.cover)
                : Container(width: 60, height: 60, color: AppColors.soft),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
                ),
                if (kcal != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$kcal kcal',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Thẻ liên kết có mũi tên sang phải.
class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      border: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: AppColors.primary),
        ],
      ),
    );
  }
}

/// Dòng có dấu ✓ hoặc vòng tròn rỗng, bấm để bật/tắt.
class CheckLine extends StatelessWidget {
  const CheckLine({
    super.key,
    required this.label,
    required this.checked,
    this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!checked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: checked
                  ? const Icon(Icons.check, size: 18, color: AppColors.ink)
                  : const Icon(
                      Icons.circle_outlined,
                      size: 14,
                      color: AppColors.ink,
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14.5)),
            ),
          ],
        ),
      ),
    );
  }
}
