import 'package:flutter_app_factory_base/core/photo/photo_picker_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final photoPickerServiceProvider = Provider<PhotoPickerService>((ref) {
  return PhotoPickerService(ImagePicker());
});
