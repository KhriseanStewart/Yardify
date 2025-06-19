import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImportImage {
  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Function to take a photo with camera
  Future<File?> takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Function to request permissions
  Future<bool> requestPermissions() async {
    // final statusCamera = await Permission.camera.status;
    final statusStorage = await Permission.storage.status;

    // if (!statusCamera.isGranted) {
    //   await Permission.camera.request();
    // }
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }

    // Recheck permissions
    // final newStatusCamera = await Permission.camera.status;
    final newStatusStorage = await Permission.storage.status;

    print("$newStatusStorage");

    return newStatusStorage.isGranted;
  }
}
