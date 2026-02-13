import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class ImageSearchService {
  static final ImageSearchService _instance = ImageSearchService._internal();
  factory ImageSearchService() => _instance;
  ImageSearchService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<String?> pickFromGallery() async {
    try {
      // Request permission
      if (!await _requestGalleryPermission()) {
        debugPrint('Gallery permission denied');
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      return image?.path;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Capture image from camera
  Future<String?> captureFromCamera() async {
    try {
      // Request permission
      if (!await _requestCameraPermission()) {
        debugPrint('Camera permission denied');
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      return image?.path;
    } catch (e) {
      debugPrint('Error capturing image from camera: $e');
      return null;
    }
  }

  /// Request camera permission
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request gallery permission
  Future<bool> _requestGalleryPermission() async {
    // For Android 13+ (Tiramisu), use photos permission
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.photos.request();
      if (status.isGranted) return true;

      // Fallback to storage permission for older Android
      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }

    return true;
  }

  /// Check if camera permission is granted
  Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }

  /// Check if gallery permission is granted
  Future<bool> isGalleryPermissionGranted() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await Permission.photos.isGranted ||
          await Permission.storage.isGranted;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await Permission.photos.isGranted;
    }
    return true;
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
