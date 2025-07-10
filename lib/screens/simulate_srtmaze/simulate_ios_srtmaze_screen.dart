
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class SimulateIOSsrtmazescreen extends StatefulWidget {
  const SimulateIOSsrtmazescreen({super.key});

  @override
  State<SimulateIOSsrtmazescreen> createState() => _SimulateIOSsrtmazescreenState();
}

class _SimulateIOSsrtmazescreenState extends State<SimulateIOSsrtmazescreen> {
  late ARKitController arkitController;
  final List<String> _nodeNames = [];
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_nodeNames.isNotEmpty) 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                        elevation: 6,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: _nodeNames.isEmpty ? null : removeAllNodes,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: ColorStyles.accent,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildNavButton('Single Panel', 0, isLeft: true),
                          _buildNavButton('Sample Layout', 1, isLeft: false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: true,
            left: true,
            child: Positioned(
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

  void removeAllNodes() {
    for (final name in _nodeNames) {
      arkitController.remove(name);
    }
    setState(() {
      _nodeNames.clear();
    });
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
      name: "model_${_nodeNames.length}",
      position: position,
      scale: _selectedModel == 0 ? vm.Vector3(0.5, 0.5, 0.5) : vm.Vector3(0.05, 0.05, 0.05),
      eulerAngles: vm.Vector3(cameraYaw, 0, 0)
    );

    arkitController.add(node);
    setState(() {
      _nodeNames.add(node.name);
    });
  }
}