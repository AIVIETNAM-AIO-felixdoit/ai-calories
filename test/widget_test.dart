import 'dart:typed_data';

import 'package:ai_calories/main.dart';
import 'package:ai_calories/services/api_client.dart';
import 'package:ai_calories/services/photo_picker.dart';
import 'package:ai_calories/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Backend giả: trả về đúng định dạng JSON của API thật (docs/examples).
class FakeApi extends AiCaloriesApi {
  FakeApi() : super(baseUrl: 'http://fake');

  List<double> lastGrams = [];

  @override
  Future<List<FoodPrediction>> predict(Uint8List bytes, {String filename = 'meal.jpg', int topK = 3}) async => [
        FoodPrediction.fromJson(const {
          'canonical_id': 'food-v2-023',
          'name_vi': 'Cơm tấm',
          'display_name': 'Cơm tấm',
          'score': 0.82,
        }),
        FoodPrediction.fromJson(const {
          'canonical_id': 'food-v2-291',
          'name_vi': 'bo-kho',
          'display_name': 'bo-kho',
          'score': 0.1,
        }),
      ];

  @override
  Future<FoodLookup> food(String canonicalId) async {
    if (canonicalId != 'food-v2-023') {
      return FoodLookup.fromJson({'canonical_id': canonicalId, 'mapped': false, 'food': null, 'recipes': []});
    }
    return FoodLookup.fromJson(const {
      'mapped': true,
      'food': {'id': 1, 'name_vi': 'Cơm tấm', 'name_en': 'Broken Rice'},
      'recipes': [
        {'id': 2, 'name': 'Cơm tấm (tham khảo)', 'default_serving_g': 300.0, 'profile_type': 'as_served_reference'},
      ],
    });
  }

  @override
  Future<RecipeDetail> recipe(int recipeId) async => RecipeDetail.fromJson(const {
        'profile_type': 'as_served_reference',
        'recipe_id': 2,
        'food_name': 'Cơm tấm',
        'recipe_name': 'Cơm tấm (tham khảo)',
        'default_serving_g': 300.0,
        'components': [
          {'ingredient_id': 9, 'name': 'Cơm tấm', 'grams': 300.0, 'is_optional': false},
        ],
      });

  @override
  Future<NutritionResult> calculate(int recipeId, List<RecipeComponent> components) async {
    lastGrams = [for (final c in components) c.grams];
    return NutritionResult.fromJson(const {
      'nutrition': {
        'total_grams': 300.0,
        'nutrients': {
          'energy': {'name': 'Năng lượng', 'amount': 650.0, 'unit': 'kcal', 'status': 'complete'},
          'protein': {'name': 'Protein', 'amount': 30.0, 'unit': 'g', 'status': 'complete'},
          'carbohydrates': {'name': 'Carbohydrate', 'amount': 80.0, 'unit': 'g', 'status': 'complete'},
          'total_fat': {'name': 'Chất béo tổng', 'amount': 20.0, 'unit': 'g', 'status': 'complete'},
          'fiber': {'name': 'Chất xơ', 'amount': null, 'unit': 'g', 'status': 'incomplete'},
        },
      },
    });
  }
}

// PNG 1×1 hợp lệ để Image.memory giải mã được.
final _png = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, //
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0xF8, 0xCF, 0xC0, 0xF0,
  0x1F, 0x00, 0x05, 0x00, 0x01, 0xFF, 0x89, 0x99, 0x3D, 0x1D, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45,
  0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

AppState _state(FakeApi api) => AppState(
      api: api,
      photoPicker: ({required bool camera}) async => PickedPhoto(_png, 'meal.png'),
    );

void main() {
  testWidgets('Chụp ảnh → AI gợi ý → xác nhận khẩu phần → lưu nhật ký', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final api = FakeApi();

    await tester.pumpWidget(AiCaloriesApp(state: _state(api)));
    expect(find.text('Ăn uống có mục tiêu.\nTheo dõi dễ dàng.'), findsOneWidget);

    await tester.tap(find.text('Khám phá trang chủ'));
    await tester.pumpAndSettle();
    expect(find.text('Chào Giang,'), findsOneWidget);
    expect(find.text('1.500'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('camera-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('shutter')));
    await tester.pumpAndSettle();
    expect(find.text('Kiểm tra bữa ăn'), findsOneWidget);
    expect(find.text('82%'), findsOneWidget);
    expect(find.text('Khẩu phần cả món'), findsOneWidget);

    // Sửa khẩu phần 300 g -> 250 g.
    await tester.tap(find.text('Khẩu phần cả món'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '250');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('250 g'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Xác nhận · xem dinh dưỡng'), 200);
    await tester.tap(find.text('Xác nhận · xem dinh dưỡng'));
    await tester.pumpAndSettle();
    expect(api.lastGrams, [250.0]);
    expect(find.text('650 kcal'), findsOneWidget);
    expect(find.text('Chưa đủ dữ liệu: Chất xơ.'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Lưu vào nhật ký'), 200);
    await tester.tap(find.text('Lưu vào nhật ký'));
    await tester.pumpAndSettle();

    // Còn lại: 2.100 - (600 + 650) = 850 kcal.
    expect(find.text('850'), findsOneWidget);
    expect(find.text('Cơm tấm'), findsOneWidget);
  });

  testWidgets('Món chưa có dữ liệu dinh dưỡng thì không cho xác nhận', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(AiCaloriesApp(state: _state(FakeApi())));
    await tester.tap(find.text('Khám phá trang chủ'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('camera-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('shutter')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bo kho'));
    await tester.pumpAndSettle();
    expect(find.textContaining('chưa có dữ liệu dinh dưỡng'), findsOneWidget);
  });

  testWidgets('Thêm nước cập nhật tổng lượng nước', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(AiCaloriesApp(state: _state(FakeApi())));
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
