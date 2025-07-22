
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/screens/widgets/ios_camera_view.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _checkPermissionAndInitCamera();
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
                            IOSCameraView(),
                            Container(
                              color: _selectedMode == 0
                                  ? Colors.black.withAlpha(200)
                                  : Colors.black.withAlpha(175),
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