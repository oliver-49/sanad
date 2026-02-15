import 'package:flutter/material.dart';
import 'package:text_to_or_from_speech_app/cubit/sanad_cubit.dart';
import 'package:text_to_or_from_speech_app/data/repostory/response_repo.dart';
import 'package:text_to_or_from_speech_app/data/web_service/api.dart';
import 'package:text_to_or_from_speech_app/helper.dart/services/camera_service.dart';
import 'package:text_to_or_from_speech_app/helper.dart/services/inreview/tts_service.dart';
import 'home_page.dart';
import 'vision_page.dart';
import '../../helper.dart/services/text_to_speach.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});
  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  bool _isManualJump = false;

  late final ResponseRepo responseRepo;
  late final SanadCubit sanadCubit;

  final List<String> _pageNames = [
    // "الشاشة الرئيسية",
    "أهلاً بك في سند. قل واحد للعملات، اثنان للأجسام، أو ثلاثة للنصوص.",
    "وضع العملات",
    "وضع الأجسام",
    "وضع قراءة النصوص",
  ];
  void initState() {
    super.initState();
    responseRepo = ResponseRepo(api: Api());
    sanadCubit = SanadCubit(responseRepo);
    // TextToSpeach.speak(_pageNames[0]);
    CameraManager().init();
  }

  @override
  void dispose() {
    CameraManager().dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!_isManualJump) {
      // VoiceService.speak(_pageNames[index]);
    }

    setState(() {
      _currentIndex = index;
    });
    _isManualJump = false;
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    _isManualJump = true;
    // VoiceService.speak(_pageNames[index]);

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sanadCubit,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            HomePage(onSelect: _onItemTapped),
            VisionPage(
              onSelect: _onItemTapped,
              mode: "Currency",
              title: "Currency Mode",
            ),
            VisionPage(
              onSelect: _onItemTapped,
              mode: "Object",
              title: "Object Mode",
            ),
            VisionPage(
              onSelect: _onItemTapped,
              mode: "Read Text",
              title: "Read Text Mode",
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Currency'),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Object',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_fields),
              label: 'Text',
            ),
          ],
        ),
      ),
    );
  }
}
