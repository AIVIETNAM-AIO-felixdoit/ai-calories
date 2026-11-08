import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_calories/main.dart';

void main() {
  testWidgets('Đi từ màn chào vào trang chủ và lưu bữa trưa', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AiCaloriesApp());
    expect(find.text('Ăn uống có mục tiêu.\nTheo dõi dễ dàng.'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Khám phá trang chủ'), 200);
    await tester.tap(find.text('Khám phá trang chủ'));
    await tester.pumpAndSettle();
    expect(find.text('Chào Giang,'), findsOneWidget);
    expect(find.text('1.500 kcal'), findsOneWidget);

    // Lưu bữa trưa qua màn chi tiết: còn lại 2.100 - 1.250 = 850 kcal.
    await tester.scrollUntilVisible(find.text('+  Chụp / tải bữa ăn'), 200);
    await tester.ensureVisible(find.text('+  Chụp / tải bữa ăn'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+  Chụp / tải bữa ăn'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+  Chụp ảnh bữa ăn'));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('Kiểm tra bữa ăn'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Xác nhận · xem dinh dưỡng'), 200);
    await tester.tap(find.text('Xác nhận · xem dinh dưỡng'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Lưu vào nhật ký'), 200);
    await tester.tap(find.text('Lưu vào nhật ký'));
    await tester.pumpAndSettle();

    expect(find.text('850 kcal'), findsOneWidget);
  });

  testWidgets('Thêm nước cập nhật tổng lượng nước', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AiCaloriesApp());
    await tester.scrollUntilVisible(find.text('Khám phá trang chủ'), 200);
    await tester.tap(find.text('Khám phá trang chủ'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('+  Thêm 250 ml'), 200);
    await tester.ensureVisible(find.text('+  Thêm 250 ml'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+  Thêm 250 ml'));
    await tester.pumpAndSettle();
    expect(find.text('1.500 ml'), findsOneWidget);
    expect(find.text('Còn 500 ml tới mục tiêu.'), findsOneWidget);
  });
}
