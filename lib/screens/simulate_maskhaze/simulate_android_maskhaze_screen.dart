
import 'dart:async';
import 'dart:ui';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:permission_handler/permission_handler.dart';

class Simulateandroidmaskhazescreen extends StatefulWidget {
  const Simulateandroidmaskhazescreen({super.key});

  @override
  State<Simulateandroidmaskhazescreen> createState() => _SimulateandroidmaskhazescreenState();
}

class _SimulateandroidmaskhazescreenState extends State<Simulateandroidmaskhazescreen> with SingleTickerProviderStateMixin {
  late ARKitController arkitController;
  late AnimationController _blurController;
  late Animation<double> _blurAnimation;
  double _targetBlur = 8.0; // Maximum blur

  bool _objectIsClose = false;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _selectedMode = 0; // 0: Maskhaze, 1: Maskhaze Light
  bool _permissionDenied = false;
  bool _checkingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInitCamera();

    _blurController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 10.0).animate(_blurController);
  }

  Future<void> _checkPermissionAndInitCamera() async {
    setState(() {
      _checkingPermission = true;
      _permissionDenied = false;
    });
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initCamera();
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

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
    await _controller?.setFocusMode(FocusMode.locked);
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;

    _startObjectCheckLoop();
  }

  void _checkForCloseObject() async {
    final results = await arkitController.performHitTest(
      x: 0.3,
      y: 0.3,
    );

    if (results.isNotEmpty) {
      final distance = results.first.distance; // in meters
      final newBlur = (distance * 15).clamp(0.0, 8.0); // map distance to blur (closer = less blur)

      if ((newBlur - _targetBlur).abs() > 0.1) {
        setState(() {
          _targetBlur = newBlur;
          _blurAnimation = Tween<double>(
            begin: _blurAnimation.value,
            end: _targetBlur,
          ).animate(CurvedAnimation(
            parent: _blurController,
            curve: Curves.easeInOut,
          ));

          _blurController.forward(from: 0.0);
        });
      }
    }
  }

  void _startObjectCheckLoop() {
    Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (mounted) _checkForCloseObject();
    });
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

    if (_controller == null || _initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator(color: ColorStyles.primary,));
    }

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              top: true,
              bottom: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Positioned(
                    top: 32,
                    left: 16,
                    child: Material(
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
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 3 / 5,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Expanded(
                            //   child: CameraPreview(_controller!),
                            // ),
                            Expanded(
                              child: ARKitSceneView(
                                onARKitViewCreated: onARKitViewCreated,
                              ),
                            ),
                            if (!_objectIsClose)
                              AnimatedBuilder(
                                animation: _blurAnimation,
                                builder: (context, child) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: _blurAnimation.value,
                                      sigmaY: _blurAnimation.value,
                                    ),
                                    child: Container(color: Colors.black.withAlpha(10)),
                                  );
                                },
                              ),
                            Expanded(
                              child: Container(
                                height: double.infinity, 
                                width: double.infinity,
                                color: _selectedMode == 0 ? Colors.black.withAlpha(200) : Colors.black.withAlpha(150),
                              )
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
        child: Container(
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
    );
  }
}