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

    await tester.tap(find.text('Khám phá trang chủ'));
    await tester.pumpAndSettle();
    expect(find.text('Chào Giang,'), findsOneWidget);
    expect(find.text('1.500'), findsOneWidget);

    // Lưu bữa trưa qua màn chi tiết: còn lại 2.100 - 1.250 = 850 kcal.
    await tester.tap(find.byKey(const ValueKey('camera-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('shutter')));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('Kiểm tra bữa ăn'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Xác nhận · xem dinh dưỡng'), 200);
    await tester.tap(find.text('Xác nhận · xem dinh dưỡng'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Lưu vào nhật ký'), 200);
    await tester.tap(find.text('Lưu vào nhật ký'));
    await tester.pumpAndSettle();

    expect(find.text('850'), findsOneWidget);
  });

  testWidgets('Thêm nước cập nhật tổng lượng nước', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AiCaloriesApp());
    await tester.tap(find.text('Khám phá trang chủ'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('+ 250 ml'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('+ 250 ml'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ 250 ml'));
    await tester.pumpAndSettle();
    expect(find.text('1.500 ml'), findsOneWidget);
    expect(find.text('Còn 500 ml tới mục tiêu.'), findsOneWidget);
  });
}
