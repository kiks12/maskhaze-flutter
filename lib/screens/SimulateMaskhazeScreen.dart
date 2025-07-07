
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:maskhaze_flutter/ColorStyle.dart';
import 'package:permission_handler/permission_handler.dart';

class Simulatemaskhazescreen extends StatefulWidget {
  const Simulatemaskhazescreen({super.key});

  @override
  State<Simulatemaskhazescreen> createState() => _SimulatemaskhazescreenState();
}

class _SimulatemaskhazescreenState extends State<Simulatemaskhazescreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _selectedMode = 0; // 0: Maskhaze, 1: Maskhaze Light
  bool _permissionDenied = false;
  bool _checkingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInitCamera();
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
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPermission) {
      return const Center(child: CircularProgressIndicator());
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
      return const Center(child: CircularProgressIndicator());
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            bottom: true,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                // Overlay for darkness based on selected mode
                Container(
                  color: _selectedMode == 0
                      ? Colors.black.withOpacity(0.6) // Darker for Maskhaze
                      : Colors.black.withOpacity(0.3), // Less dark for Maskhaze Light
                ),
                Image.asset(
                  'assets/misc/maskbg.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: ColorStyles.backgroundMain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNavButton('Maskhaze', 0, isLeft: true),
                        _buildNavButton('Maskhaze Light', 1, isLeft: false),
                      ],
                    ),
                  ),
                ),
                // Floating back button on top of everything
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
                              color: Colors.black.withOpacity(0.2),
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
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildToggleButton(String label, int index) {
    final bool isSelected = _selectedMode == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14), // Remove horizontal padding for responsiveness
        decoration: BoxDecoration(
          color: isSelected ? ColorStyles.primary : ColorStyles.cardBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? ColorStyles.white : ColorStyles.textMuted,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
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
          height: 64,
          decoration: BoxDecoration(
            color: isSelected ? ColorStyles.primary : ColorStyles.cardBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isLeft ? 8 : 0),
              bottomLeft: Radius.circular(isLeft ? 8 : 0),
              topRight: Radius.circular(!isLeft ? 8 : 0),
              bottomRight: Radius.circular(!isLeft ? 8 : 0),
            ),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorStyles.white : ColorStyles.textMuted,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}