import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';

/// Người dùng xác nhận món AI gợi ý, chọn khẩu phần và chỉnh gram
/// trước khi backend tính dinh dưỡng. Model không tự đoán khối lượng.
class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key, required this.photo, required this.predictions});

  final Uint8List photo;
  final List<FoodPrediction> predictions;

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  FoodPrediction? _selected;
  FoodLookup? _food;
  RecipeDetail? _recipe;
  bool _loading = false;
  bool _calculating = false;
  String? _error;

  AiCaloriesApi get _api => AppScope.read(context).api;

  @override
  void initState() {
    super.initState();
    if (widget.predictions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _choose(widget.predictions.first));
    }
  }

  Future<void> _choose(FoodPrediction prediction) async {
    setState(() {
      _selected = prediction;
      _food = null;
      _recipe = null;
      _error = null;
      _loading = true;
    });
    try {
      final food = await _api.food(prediction.canonicalId);
      RecipeDetail? recipe;
      if (food.mapped && food.recipes.isNotEmpty) {
        recipe = await _api.recipe(food.recipes.first.id);
      }
      if (!mounted || _selected != prediction) return;
      setState(() {
        _food = food;
        _recipe = recipe;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || _selected != prediction) return;
      setState(() {
        _error = '$error';
        _loading = false;
      });
    }
  }

  Future<void> _chooseRecipe(RecipeOption option) async {
    setState(() => _loading = true);
    try {
      final recipe = await _api.recipe(option.id);
      if (!mounted) return;
      setState(() {
        _recipe = recipe;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = '$error';
        _loading = false;
      });
    }
  }

  Future<void> _edit(RecipeComponent component, String label) async {
    final result = await showDialog<double>(
      context: context,
      builder: (_) => _GramsDialog(label: label, initial: _grams(component.grams)),
    );
    if (result != null && result > 0 && result <= 5000) {
      setState(() => component.grams = result);
    }
  }

  Future<void> _confirm() async {
    final recipe = _recipe;
    if (recipe == null) return;
    setState(() => _calculating = true);
    try {
      final nutrition = await _api.calculate(recipe.recipeId, recipe.components);
      if (!mounted) return;
      final now = TimeOfDay.now();
      final meal = LoggedMeal(
        title: _food?.foodName ?? recipe.foodName,
        time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        nutrition: nutrition,
        photo: widget.photo,
      );
      setState(() => _calculating = false);
      pushScreen(context, DetailScreen(meal: meal));
    } catch (error) {
      if (!mounted) return;
      setState(() => _calculating = false);
      showToast(context, '$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _recipe;

    return AppScreen(
      children: [
        const ScreenHeader(
          title: 'Kiểm tra bữa ăn',
          subtitle: 'AI gợi ý món. Bạn xác nhận giúp mình nhé.',
        ),
        const SizedBox(height: 20),
        FoodImage(height: 190, bytes: widget.photo),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: PillBadge(label: 'AI GỢI Ý · CHỌN MÓN ĐÚNG'),
        ),
        const SizedBox(height: 12),
        if (widget.predictions.isEmpty)
          const Caption('AI chưa nhận ra món nào. Hãy chụp lại rõ hơn.')
        else
          for (final p in widget.predictions)
            _CandidateTile(
              prediction: p,
              selected: p == _selected,
              onTap: () => _choose(p),
            ),
        const SizedBox(height: 12),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          )
        else if (_error != null)
          AppCard(color: AppColors.soft, child: Text(_error!))
        else if (_food != null && recipe == null)
          const AppCard(
            color: AppColors.soft,
            child: Text(
              'Món này chưa có dữ liệu dinh dưỡng trong hệ thống. '
              'Hãy chọn món khác gần đúng hoặc chụp lại.',
            ),
          )
        else if (recipe != null) ...[
          Text(
            _food?.foodName ?? recipe.foodName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          if ((_food?.recipes.length ?? 0) > 1) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in _food!.recipes)
                  ChoiceChip(
                    label: Text(r.name),
                    selected: r.id == recipe.recipeId,
                    onSelected: (_) => _chooseRecipe(r),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          AppCard(
            border: true,
            padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipe.isAsServed)
                  for (final c in recipe.components)
                    _PortionRow(
                      label: 'Khẩu phần cả món',
                      grams: c.grams,
                      onEdit: () => _edit(c, 'Khẩu phần cả món'),
                    )
                else
                  for (final c in recipe.components)
                    _PortionRow(
                      label: c.isOptional ? '${c.name} (tuỳ chọn)' : c.name,
                      grams: c.grams,
                      onEdit: () => _edit(c, c.name),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Caption(
            recipe.isAsServed
                ? 'Số liệu theo món tham khảo (USDA). Chỉnh tổng gram cho đúng phần bạn ăn.'
                : 'Khối lượng từng thành phần có thể khác thực tế. Hãy kiểm tra trước khi lưu.',
          ),
        ],
        const SizedBox(height: 20),
        PrimaryButton(
          label: _calculating ? 'Đang tính…' : 'Xác nhận · xem dinh dưỡng',
          onPressed: recipe == null || _loading || _calculating ? null : _confirm,
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

String _grams(double g) => g == g.roundToDouble() ? g.toInt().toString() : g.toStringAsFixed(1);

/// Hộp thoại tự giữ controller để chỉ huỷ sau khi hiệu ứng đóng kết thúc.
class _GramsDialog extends StatefulWidget {
  const _GramsDialog({required this.label, required this.initial});

  final String label;
  final String initial;

  @override
  State<_GramsDialog> createState() => _GramsDialogState();
}

class _GramsDialogState extends State<_GramsDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.label),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(suffixText: 'g'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context)
              .pop(double.tryParse(_controller.text.replaceAll(',', '.'))),
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

class _CandidateTile extends StatelessWidget {
  const _CandidateTile({required this.prediction, required this.selected, required this.onTap});

  final FoodPrediction prediction;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        border: !selected,
        color: selected ? AppColors.soft : AppColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                prediction.displayName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '${(prediction.score * 100).round()}%',
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortionRow extends StatelessWidget {
  const _PortionRow({required this.label, required this.grams, this.onEdit});

  final String label;
  final double grams;
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
                label,
                style: const TextStyle(fontSize: 15, color: AppColors.muted),
              ),
            ),
            Text(
              '${_grams(grams)} g',
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
