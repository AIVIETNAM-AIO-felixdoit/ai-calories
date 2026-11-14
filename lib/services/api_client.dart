import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Địa chỉ backend. Đổi khi chạy bằng:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
/// Mặc định: Android emulator gọi máy host qua 10.0.2.2, nền tảng khác dùng 127.0.0.1.
String defaultApiBaseUrl() {
  const fromEnv = String.fromEnvironment('API_BASE_URL');
  if (fromEnv.isNotEmpty) return fromEnv;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://127.0.0.1:8000';
}

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class FoodPrediction {
  const FoodPrediction({
    required this.canonicalId,
    required this.displayName,
    required this.score,
  });

  factory FoodPrediction.fromJson(Map<String, dynamic> json) => FoodPrediction(
        canonicalId: json['canonical_id'] as String,
        displayName: prettyFoodName(
          (json['name_vi'] ?? json['display_name'] ?? json['name_en'] ?? json['canonical_id'])
              as String,
        ),
        score: (json['score'] as num).toDouble(),
      );

  final String canonicalId;
  final String displayName;

  /// Softmax chưa hiệu chỉnh, chỉ để xếp hạng, không phải độ chắc chắn.
  final double score;
}

class RecipeOption {
  const RecipeOption({
    required this.id,
    required this.name,
    required this.defaultServingG,
    required this.profileType,
  });

  factory RecipeOption.fromJson(Map<String, dynamic> json) => RecipeOption(
        id: json['id'] as int,
        name: json['name'] as String,
        defaultServingG: (json['default_serving_g'] as num?)?.toDouble(),
        profileType: json['profile_type'] as String? ?? 'unreviewed',
      );

  final int id;
  final String name;
  final double? defaultServingG;
  final String profileType;
}

class FoodLookup {
  const FoodLookup({required this.mapped, this.foodName, this.recipes = const []});

  factory FoodLookup.fromJson(Map<String, dynamic> json) {
    final food = json['food'] as Map<String, dynamic>?;
    return FoodLookup(
      mapped: json['mapped'] as bool? ?? false,
      foodName: food == null ? null : (food['name_vi'] ?? food['name_en']) as String?,
      recipes: [
        for (final r in (json['recipes'] as List? ?? const []))
          RecipeOption.fromJson(r as Map<String, dynamic>),
      ],
    );
  }

  final bool mapped;
  final String? foodName;
  final List<RecipeOption> recipes;
}

class RecipeComponent {
  RecipeComponent({
    required this.ingredientId,
    required this.name,
    required this.grams,
    this.isOptional = false,
  });

  factory RecipeComponent.fromJson(Map<String, dynamic> json) => RecipeComponent(
        ingredientId: json['ingredient_id'] as int,
        name: json['name'] as String,
        grams: (json['grams'] as num).toDouble(),
        isOptional: json['is_optional'] as bool? ?? false,
      );

  final int ingredientId;
  final String name;
  double grams;
  final bool isOptional;
}

class RecipeDetail {
  const RecipeDetail({
    required this.recipeId,
    required this.foodName,
    required this.recipeName,
    required this.profileType,
    required this.defaultServingG,
    required this.components,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) => RecipeDetail(
        recipeId: json['recipe_id'] as int,
        foodName: json['food_name'] as String? ?? '',
        recipeName: json['recipe_name'] as String? ?? '',
        profileType: json['profile_type'] as String? ?? 'unreviewed',
        defaultServingG: (json['default_serving_g'] as num?)?.toDouble(),
        components: [
          for (final c in (json['components'] as List? ?? const []))
            RecipeComponent.fromJson(c as Map<String, dynamic>),
        ],
      );

  final int recipeId;
  final String foodName;
  final String recipeName;

  /// `as_served_reference`: 1 thành phần = cả món, chỉ sửa tổng gram.
  /// `ingredient_recipe`: sửa gram từng nguyên liệu.
  final String profileType;
  final double? defaultServingG;
  final List<RecipeComponent> components;

  bool get isAsServed => profileType == 'as_served_reference';
}

class Nutrient {
  const Nutrient({required this.name, required this.amount, required this.unit, required this.complete});

  factory Nutrient.fromJson(Map<String, dynamic> json) => Nutrient(
        name: json['name'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble(),
        unit: json['unit'] as String? ?? '',
        complete: json['status'] == 'complete',
      );

  final String name;

  /// null = thiếu dữ liệu. Không được hiển thị thành 0.
  final double? amount;
  final String unit;
  final bool complete;
}

class NutritionResult {
  const NutritionResult({required this.totalGrams, required this.nutrients});

  factory NutritionResult.fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>;
    final raw = nutrition['nutrients'] as Map<String, dynamic>? ?? const {};
    return NutritionResult(
      totalGrams: (nutrition['total_grams'] as num?)?.toDouble() ?? 0,
      nutrients: {
        for (final e in raw.entries) e.key: Nutrient.fromJson(e.value as Map<String, dynamic>),
      },
    );
  }

  final double totalGrams;
  final Map<String, Nutrient> nutrients;

  Nutrient? get energy => nutrients['energy'];
  Nutrient? get protein => nutrients['protein'];
  Nutrient? get carbs => nutrients['carbohydrates'];
  Nutrient? get fat => nutrients['total_fat'];
}

/// Client cho backend FastAPI (repo jermwuyn/ai-calories-app).
class AiCaloriesApi {
  AiCaloriesApi({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? defaultApiBaseUrl(),
        _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  static const _timeout = Duration(seconds: 30);

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  Future<List<FoodPrediction>> predict(Uint8List bytes, {String filename = 'meal.jpg', int topK = 3}) async {
    final request = http.MultipartRequest('POST', _uri('/predict', {'top_k': '$topK'}))
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: _mediaType(filename),
      ));
    final response = await _send(() async => http.Response.fromStream(await _client.send(request)));
    final json = _decode(response) as Map<String, dynamic>;
    return [
      for (final p in json['predictions'] as List) FoodPrediction.fromJson(p as Map<String, dynamic>),
    ];
  }

  Future<FoodLookup> food(String canonicalId) async {
    final response = await _send(
      () => _client.get(_uri('/foods/by-canonical/${Uri.encodeComponent(canonicalId)}')),
    );
    return FoodLookup.fromJson(_decode(response) as Map<String, dynamic>);
  }

  Future<RecipeDetail> recipe(int recipeId) async {
    final response = await _send(() => _client.get(_uri('/recipes/$recipeId')));
    return RecipeDetail.fromJson(_decode(response) as Map<String, dynamic>);
  }

  Future<NutritionResult> calculate(int recipeId, List<RecipeComponent> components) async {
    final body = jsonEncode({
      'components': [
        for (final c in components) {'ingredient_id': c.ingredientId, 'grams': c.grams},
      ],
    });
    final response = await _send(() => _client.post(
          _uri('/recipes/$recipeId/calculate'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        ));
    return NutritionResult.fromJson(_decode(response) as Map<String, dynamic>);
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      return await call().timeout(_timeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Không kết nối được máy chủ AI ($baseUrl). '
          'Kiểm tra backend đã chạy và cùng mạng chưa.');
    }
  }

  Object? _decode(http.Response response) {
    final text = utf8.decode(response.bodyBytes);
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(text);
    throw ApiException(_errorMessage(response.statusCode, text), statusCode: response.statusCode);
  }

  static String _errorMessage(int status, String body) {
    switch (status) {
      case 413:
        return 'Ảnh quá lớn (tối đa 10 MB, 20 megapixel).';
      case 415:
        return 'Chỉ hỗ trợ ảnh JPEG, PNG hoặc WebP.';
      case 503:
        return 'Máy chủ chưa nạp được model AI. Hãy chạy lại setup ở backend.';
      case 500:
        return 'Máy chủ thiếu cơ sở dữ liệu dinh dưỡng.';
    }
    try {
      final detail = (jsonDecode(body) as Map<String, dynamic>)['detail'];
      if (detail is String) return detail;
    } catch (_) {}
    return 'Máy chủ báo lỗi ($status).';
  }

  static MediaType _mediaType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      _ => MediaType('image', 'jpeg'),
    };
  }
}

/// "bo-kho" -> "Bo kho", "Banh pia" giữ nguyên.
String prettyFoodName(String raw) {
  final text = raw.replaceAll(RegExp(r'[-_]+'), ' ').trim();
  if (text.isEmpty) return raw;
  return text[0].toUpperCase() + text.substring(1);
}
