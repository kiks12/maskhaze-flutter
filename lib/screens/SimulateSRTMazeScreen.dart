
import 'dart:math' as math;

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/ColorStyle.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class Simulatesrtmazescreen extends StatefulWidget {
  const Simulatesrtmazescreen({super.key});

  @override
  State<Simulatesrtmazescreen> createState() => _SimulatesrtmazescreenState();
}

class _SimulatesrtmazescreenState extends State<Simulatesrtmazescreen> {
  late ARKitController arkitController;
  int _selectedModel = 0; // 0: Single Panel, 1: Sample Layout

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ARKitSceneView(
            onARKitViewCreated: onARKitViewCreated,
            planeDetection: ARPlaneDetection.horizontal,
            enableTapRecognizer: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Container(
                color: ColorStyles.backgroundMain,
                child: Row(
                  children: [
                    _buildNavButton('Single Panel', 0, isLeft: true),
                    _buildNavButton('Sample Layout', 1, isLeft: false),
                  ],
                ),
              ),
            ),
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
  }

  Widget _buildNavButton(String label, int index, {required bool isLeft}) {
    final bool isSelected = _selectedModel == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedModel = index;
          });
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? ColorStyles.primary : ColorStyles.backgroundMain,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isLeft ? 8 : 0),
              bottomLeft: Radius.circular(isLeft ? 8 : 0),
              topRight: Radius.circular(!isLeft ? 8 : 0),
              bottomRight: Radius.circular(!isLeft ? 8 : 0),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorStyles.textMain : ColorStyles.textMuted,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onARTap = onARTapHandler;
  }

  void onARTapHandler(List<ARKitTestResult> hits) async {
    if (hits.isEmpty) return;

    final hit = hits.firstWhere(
      (h) => h.type == ARKitHitTestResultType.existingPlane,
      orElse: () => hits.first,
    );

    final cameraTransform = await arkitController.getCameraEulerAngles();
    final cameraYaw = cameraTransform.y;

    final position = hit.worldTransform.getTranslation();
    final modelUrl = _selectedModel == 0 ? 'SinglePanel.usdz' : 'SampleLayout3.usdz';

    final node = ARKitReferenceNode(
      url: modelUrl,
      position: position,
      scale: _selectedModel == 0 ? vm.Vector3(0.5, 0.5, 0.5) : vm.Vector3(0.05, 0.05, 0.05),
    );

    arkitController.add(node);
  }

  // Future<File> _loadGLBModelToFile(String assetPath) async {
  //   final byteData = await rootBundle.load(assetPath);
  //   final buffer = byteData.buffer;

  //   final tempDir = await getTemporaryDirectory(); // safer on iOS
  //   final filePath = '${tempDir.path}/${assetPath.split("/").last}';

  //   final file = await File(filePath).writeAsBytes(
  //     buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  //   );

  //   final exists = await file.exists();
  //   final size = await file.length();
  //   print("✅ File written to: $filePath");
  //   print("📦 Exists: $exists, Size: $size bytes");


  //   print('File path: $filePath');
  //   return file;
  // }

  // Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
  //   if (hitTestResults.isEmpty) return;
  //   final hit = hitTestResults.first;
  //   // Add anchor at the tapped point
  //   final newAnchor = ARPlaneAnchor(transformation: hit.worldTransform);
  //   final success = await arAnchorManager?.addAnchor(newAnchor);
  //   if (success == true) {
  //     anchors.add(newAnchor);
  //     // Copy model to temp dir and get file URI
  //     final modelUri = await _loadGLBModelToFile('assets/models/Duck.glb');
  //     if (!await modelUri.exists()) {
  //       print("❌ ERROR: File does not exist at ${modelUri.path}");
  //       return;
  //     } else {
  //       print("✅ File exists at ${modelUri.path}");
  //     }
  //     // Add the 3D model to the anchor
  //     final node = ARNode(
  //       type: NodeType.webGLB,
  //       uri: modelUri.path,
  //       scale: Vector3(1, 1, 1),
  //       position: Vector3(0.0, 0.0, 0.0),
  //       rotation: Vector4(0.0, 0.0, 0.0, 0.0),
  //     );
  //     await Future.delayed(Duration(milliseconds: 500));
  //     final didAdd = await arObjectManager?.addNode(node, planeAnchor: newAnchor);

  //     if (didAdd == true) {
  //       print("✅ Duck.glb added to scene!");
  //     } else {
  //       print("❌ Failed to add Duck.glb");
  //     }
  //     setState(() {});
  //   }
  // }
}