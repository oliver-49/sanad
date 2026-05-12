import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CameraPage extends StatefulWidget {
  final String mode;
  CameraPage({required this.mode});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _tts.speak("Switching to ${widget.mode} mode");
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Icon(Icons.graphic_eq, size: 60, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(
                    "${widget.mode} Result...",
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () => _tts.speak("Analyzing ${widget.mode}"),
                    child: Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
