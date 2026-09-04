import 'package:image_picker/image_picker.dart';

class GalleryService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    return _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
  }
}
