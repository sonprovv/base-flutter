import 'package:image_picker/image_picker.dart';

class PhotoPickerService {
  PhotoPickerService(this._picker);

  final ImagePicker _picker;

  Future<String?> pickFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 90,
    );
    return file?.path;
  }

  Future<String?> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    return file?.path;
  }
}
