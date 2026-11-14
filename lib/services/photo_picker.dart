import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PickedPhoto {
  const PickedPhoto(this.bytes, this.filename);

  final Uint8List bytes;
  final String filename;
}

typedef PhotoPicker = Future<PickedPhoto?> Function({required bool camera});

/// Mở camera (hoặc thư viện ảnh). Trên Windows/macOS/Linux không có camera
/// qua image_picker nên luôn mở thư viện.
Future<PickedPhoto?> pickPhoto({required bool camera}) async {
  final desktop = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux);
  final file = await ImagePicker().pickImage(
    source: camera && !desktop ? ImageSource.camera : ImageSource.gallery,
    // Model chạy ở 224×224; thu nhỏ để upload nhanh và nằm dưới giới hạn 10 MB.
    maxWidth: 1600,
    maxHeight: 1600,
    imageQuality: 85,
  );
  if (file == null) return null;
  final name = file.name.isEmpty ? 'meal.jpg' : file.name;
  return PickedPhoto(await file.readAsBytes(), name);
}
