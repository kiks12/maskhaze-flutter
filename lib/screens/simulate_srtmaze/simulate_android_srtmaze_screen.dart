import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> copyAssetToFile(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/${assetPath.split('/').last}');
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file.path;
}

class Simulateandroidsrtmazescreen extends StatefulWidget {
  const Simulateandroidsrtmazescreen({super.key});

  @override
  State<Simulateandroidsrtmazescreen> createState() => _SimulateandroidsrtmazescreenState();
}

class _SimulateandroidsrtmazescreenState extends State<Simulateandroidsrtmazescreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  final List<ARNode> _nodes = [];
  int _selectedModel = 0;

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  void onARViewCreated(ARSessionManager sessionManager, ARObjectManager objectManager, ARAnchorManager anchorManager, ARLocationManager locationManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      handleTaps: true,
    );

    arObjectManager.onInitialize();

    arSessionManager.onPlaneOrPointTap = onPlaneTap;
  }

  Future<void> onPlaneTap(List<ARHitTestResult> hits) async {
    if (hits.isEmpty) return;

    try {
      final hit = hits.first;

      final localPath = await copyAssetToFile(
        _selectedModel == 0
            ? 'assets/models/SinglePanel.glb'
            : 'assets/models/SampleLayout2.glb',
      );

      final node = ARNode(
        type: NodeType.webGLB,
        uri: 'file://$localPath',
        scale: vm.Vector3.all(1),
        position: hit.worldTransform.getTranslation(),
        eulerAngles: vm.Vector3(hit.worldTransform.getTranslation().x, 0, 0),
      );

      bool didAdd = await arObjectManager.addNode(node) ?? false;
      if (didAdd) {
        setState(() {
          _nodes.add(node);
        });
      }
    } catch(e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: ColorStyles.backgroundMain,
              iconColor: ColorStyles.primary,
              title: const Text("Object Render Failed", style: TextStyle(color: ColorStyles.textMain),),
              content: const Text("Cannot find surface to anchor object.", style: TextStyle(color: ColorStyles.textLight),),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(ColorStyles.primary),
                  ),
                  child: const Text("OK", style: TextStyle(color: ColorStyles.textMain),),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_nodes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                        elevation: 6,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: () async {
                            for (final node in _nodes) {
                              await arObjectManager.removeNode(node);
                            }
                            setState(() {
                              _nodes.clear();
                            });
                          },
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
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.white),
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
}
