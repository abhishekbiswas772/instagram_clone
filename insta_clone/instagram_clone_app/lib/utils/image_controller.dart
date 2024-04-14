import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController {
  static Future<Uint8List?> picImage(ImageSource source) async {
    final ImagePicker __imagePicker = ImagePicker();
    XFile? __imageFile = await __imagePicker.pickImage(source: source);
    if (__imageFile != null) {
      return await __imageFile.readAsBytes();
    }else{
      return null;
    }
  }
}
