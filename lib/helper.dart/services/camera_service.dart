import 'package:camera/camera.dart';

class CameraManager {
  static final CameraManager _instance = CameraManager._internal();
  factory CameraManager() => _instance;
  CameraManager._internal();

  CameraController? controller;
  bool isInitialized = false;

  Future<void> init() async {
    if (isInitialized) return;
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.high);
      await controller!.initialize();
      isInitialized = true;
    }
  }

  void dispose() {
    controller?.dispose();
    controller = null;
    isInitialized = false;
  }
}
