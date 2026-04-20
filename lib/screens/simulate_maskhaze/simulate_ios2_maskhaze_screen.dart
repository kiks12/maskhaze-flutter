
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/screens/widgets/ios_camera_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:maskhaze_flutter/utils/tutorial_helper.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Simulateios2maskhazescreen extends StatefulWidget {
  const Simulateios2maskhazescreen({super.key});

  @override
  State<Simulateios2maskhazescreen> createState() => _Simulateios2maskhazescreenState();
}

class _Simulateios2maskhazescreenState extends State<Simulateios2maskhazescreen> with SingleTickerProviderStateMixin {
  Future<void>? _initializeControllerFuture;
  int _selectedMode = 0; // 0: Maskhaze, 1: Maskhaze Light
  bool _permissionDenied = false;
  bool _checkingPermission = true;
  double? _originalBrightness;
  bool _cameraInitialized = false; // New flag

  List<TargetFocus> targets = [];
  GlobalKey keyBackButton = GlobalKey();
  GlobalKey keyCameraView = GlobalKey();
  GlobalKey keyMaskhazeButton = GlobalKey();
  GlobalKey keyMaskhazeLightButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _checkPermissionAndInitCamera();
    _setBrightness();
  }

  void _initTutorial() {
    targets.add(
      TargetFocus(
        keyTarget: keyBackButton,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect, // Corrected to RRect
        radius: 22, // Half of the button's width/height
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Back Button",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Tap here to return to the home screen.",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        keyTarget: keyCameraView,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect, // Corrected to RRect
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Live Camera Feed",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "This is your live camera feed, simulating the Maskhaze effect.",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        keyTarget: keyMaskhazeButton,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect, // Corrected to RRect
        radius: 50, // Matches the button's rounded ends
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Maskhaze Mode",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Switch to the standard Maskhaze simulation mode.",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        keyTarget: keyMaskhazeLightButton,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect, // Corrected to RRect
        radius: 50, // Matches the button's rounded ends
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Maskhaze Light Mode",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Experience a lighter version of the Maskhaze effect.",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TutorialHelper.showTutorial(
        context: context,
        targets: targets,
        screenId: 'ios_maskhaze_tutorial',
        onFinish: () {
          print("iOS Maskhaze Tutorial finished!");
        },
        onSkip: () {
          print("iOS Maskhaze Tutorial skipped!");
        },
      );
    });
  }

  Future<void> _setBrightness() async {
    try {
      // Store original brightness
      _originalBrightness = await ScreenBrightness().current;
      // Set brightness to 80%
      await ScreenBrightness().setScreenBrightness(0.8);
    } catch (e) {
      print('Error setting brightness: $e');
    }
  }

  Future<void> _checkPermissionAndInitCamera() async {
    setState(() {
      _checkingPermission = true;
      _permissionDenied = false;
    });
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _checkingPermission = false;
      });
    } else {
      setState(() {
        _permissionDenied = true;
        _checkingPermission = false;
      });
    }
  }

  @override
  void dispose() {
    // Restore original brightness
    if (_originalBrightness != null) {
      ScreenBrightness().setScreenBrightness(_originalBrightness!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPermission) {
      return const Center(child: CircularProgressIndicator(color: ColorStyles.primary,));
    }
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Camera permission denied. Please enable it in settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: const Text('Open App Settings'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _checkPermissionAndInitCamera,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator(color: ColorStyles.primary,));
    }

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // No NativeCameraController.setManualFocus for iOS, but we still need to ensure camera is ready
          if (!_cameraInitialized) {
            _cameraInitialized = true;
            _initTutorial(); // Call _initTutorial here
          }
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  // AR and Blur
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 3 / 5,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Builder(
                              key: keyCameraView,
                              builder: (context) => IOSCameraView(),
                            ),
                            Container(
                              color: _selectedMode == 0
                                  ? Colors.black.withAlpha(230)
                                  : Colors.black.withAlpha(200),
                            ),
                            Image.asset(
                              'assets/misc/maskbg.png',
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 56,
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildNavButton('Maskhaze', 0, isLeft: true),
                              _buildNavButton('Maskhaze Light', 1, isLeft: false),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 32,
                    left: 16,
                    child: Builder(
                      key: keyBackButton,
                      builder: (context) => Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        elevation: 4,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: ColorStyles.cardBackground,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(32),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator(color: ColorStyles.primary,));
        }
      },
    );
  }

  Widget _buildNavButton(String label, int index, {required bool isLeft}) {
    final bool isSelected = _selectedMode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMode = index;
          });
        },
        child: Builder(
          key: isLeft ? keyMaskhazeButton : keyMaskhazeLightButton,
          builder: (context) => Container(
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? ColorStyles.primary : ColorStyles.cardBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isLeft ? 50 : 0),
                bottomLeft: Radius.circular(isLeft ? 50 : 0),
                topRight: Radius.circular(!isLeft ? 50 : 0),
                bottomRight: Radius.circular(!isLeft ? 50 : 0),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? ColorStyles.textMain : ColorStyles.textMuted,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}