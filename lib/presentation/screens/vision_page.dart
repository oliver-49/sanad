import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:text_to_or_from_speech_app/helper.dart/services/camera_service.dart';
import 'package:text_to_or_from_speech_app/helper.dart/services/speach_to_text.dart';
import '../../helper.dart/services/api_service.dart';
import '../../helper.dart/services/text_to_speach.dart';

class VisionPage extends StatefulWidget {
  final Function(int) onSelect;
  final String mode;
  final String title;
  const VisionPage({
    super.key,
    required this.mode,
    required this.title,
    required this.onSelect,
  });

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  // CameraController? _controller;
  CameraController? _controller = CameraManager().controller;

  String _resultText = "وجه الكاميرا واضغط للتصوير";
  bool _isLoading = false;

  bool _isPermissionRequesting = false;

  final SpeechToTextService _speechToTextService = SpeechToTextService();
  String _recognizedText = '';
  String modee = '';
  @override
  void initState() {
    super.initState();
    // _initCamera();
    modee = widget.mode == 'Currency'
        ? "وضع العملات"
        : widget.mode == 'Object'
        ? "وضع الأجسام"
        : "وضع قراءة النصوص";
    // TextToSpeach.speak(
    //   "أنت الآن في $modee ، وجه الكاميرا واضغط مرتين ع الشاشة للتصوير ,أو قل كلمة تصوير ,و للعودة قل رجوع أو اضغط ضغطة مطولاً على الشاشة",
    // );

    startingServices();
  }

  Future<void> startingServices() async {
    await TextToSpeach.speak('أنت الآن في $modee. ', isImportant: true);
    // await Future.delayed(const Duration(seconds: 3));
    await TextToSpeach.speak('''
وجه الكاميرا.
اضغط مرتين للتصوير، أو قل تصوير.
اضغط مطولاً للرجوع، أو قل رجوع.
''');

    // await
    Future.delayed(Duration(seconds: modee == "وضع قراءة النصوص" ? 14 : 12));

    if (!mounted) return;
    await _speechToTextService.init();

    if (!mounted) return; // أمان زيادة

    callToggleListening();
  }

  // delay 3 seconds then run _speechToTextService initialization

  // callingToggleListening
  void callToggleListening() async {
    _recognizedText == ''
        ? await _speechToTextService.toggleListening((text) {
            // setState(() => _recognizedText = text);
            handleVoiceCommand(text);
          })
        : null;
  }

  void handleVoiceCommand(String command) {
    final cmd = command.trim();
    print("Recognized command: $cmd");

    if (cmd.contains("رجوع") || cmd.contains("عودة")) {
      _speechToTextService.stopListening();
      TextToSpeach.stop();
      widget.onSelect(0);

      //nav to home
    } else if (cmd.contains("تصوير") ||
        cmd.contains("التقط") ||
        cmd.contains("التقاط") ||
        cmd.contains("صور") ||
        cmd.contains("التقاط الصورة")) {
      _capture();
    }
  }

  Future<void> _initCamera() async {
    if (_controller != null && _controller!.value.isInitialized) return;

    if (_isPermissionRequesting) return;
    _isPermissionRequesting = true;

    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        _isPermissionRequesting = false;
        return;
      }
    }

    _isPermissionRequesting = false;

    final cams = await availableCameras();
    if (cams.isEmpty) return;

    _controller = CameraController(cams[0], ResolutionPreset.high);

    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print("Camera init error: $e");
    }
  }

  Future<void> _capture() async {
    if (_controller == null || _isLoading) return;
    setState(() {
      _recognizedText = 'done';
      _isLoading = true;
    });

    HapticFeedback.vibrate();
    HapticFeedback.heavyImpact();
    TextToSpeach.speak("جاري التحليل", isImportant: true);

    final img = await _controller!.takePicture();
    final response = await ApiService.processImage(img.path, widget.mode);

    setState(() {
      _resultText = response;
      _isLoading = false;
    });
    TextToSpeach.speak(response, isImportant: true);
  }

  @override
  void dispose() {
    _speechToTextService.stopListening();
    // _controller?.dispose();
    // _controller = null;
    super.dispose();
  }

  @override
  void deactivate() {
    _speechToTextService.stopListening();
    super.deactivate();
  }

  void _captureWithtap() {
    if (_controller == null || _isLoading) return;
    TextToSpeach.speak("جاري التحليل", isImportant: true);
    _capture();
  }

  void _goBack() {
    _speechToTextService.stopListening();
    TextToSpeach.stop();
    TextToSpeach.speak("تم الرجوع للرئيسية", isImportant: true);
    widget.onSelect(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return InkWell(
      onDoubleTap: _captureWithtap,
      onLongPress: _goBack,
      child: Scaffold(
        body: Stack(
          children: [
            CameraPreview(_controller!),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      const Color(0xFFF5F5F5),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildWaves(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _resultText,
                        maxLines: widget.mode != "Read Text" ? 3 : 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A237E),
                          letterSpacing: 0.5,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: GestureDetector(
                        onTap: _isLoading ? null : _capture,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: _isLoading ? 1.1 : 1.0),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF1A237E),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1A237E).withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: _isLoading ? 5 : 2,
                                    ),
                                  ],
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 45,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaves() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        8,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 4,
          height: (i.isEven) ? 35 : 20,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
