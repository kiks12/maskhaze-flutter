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
import 'package:maskhaze_flutter/utils/tutorial_helper.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
  State<Simulateandroidsrtmazescreen> createState() =>
      _SimulateandroidsrtmazescreenState();
}

class _SimulateandroidsrtmazescreenState
    extends State<Simulateandroidsrtmazescreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  final List<ARNode> _nodes = [];
  int _selectedModel = 0;

  List<TargetFocus> targets = [];
  GlobalKey keyBackButton = GlobalKey();
  GlobalKey keyARView = GlobalKey();
  GlobalKey keyClearButton = GlobalKey();
  GlobalKey keySinglePanelButton = GlobalKey();
  GlobalKey keySampleLayoutButton = GlobalKey();

  @override
  void initState() {
    super.initState(); // Corrected from super.dispose()
    _initTutorial();
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
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

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
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
                    fontSize: 20.0,
                  ),
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
        keyTarget: keyARView,
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
                  "AR View",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "This is your Augmented Reality view. Tap on a detected plane to place a maze panel.",
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
        keyTarget: keySinglePanelButton,
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
                  "Single Panel Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Select this to place individual maze panels in the AR environment.",
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
        keyTarget: keySampleLayoutButton,
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
                  "Sample Layout Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Choose this to place a pre-designed sample maze layout.",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Only add clear button tutorial if it's visible (i.e., _nodes is not empty)
    // This will be handled by checking _nodes.isNotEmpty in the build method
    // and then calling showTutorial. For now, we'll assume it might be added later.
    // For initial tutorial, we might not have nodes yet.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TutorialHelper.showTutorial(
        context: context,
        targets: targets,
        screenId: 'android_srtmaze_tutorial',
        onFinish: () {
          print("Android SRTMaze Tutorial finished!");
        },
        onSkip: () {
          print("Android SRTMaze Tutorial skipped!");
        },
      );
    });
  }

  Future<void> onPlaneTap(List<ARHitTestResult> hits) async {
    if (hits.isEmpty) return;

    try {
      final hit = hits.first;

      final localPath = await copyAssetToFile(
        _selectedModel == 0
            ? 'assets/models/Single.glb'
            : 'assets/models/Multiple.glb',
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
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: ColorStyles.backgroundMain,
              iconColor: ColorStyles.primary,
              title: const Text(
                "Object Render Failed",
                style: TextStyle(color: ColorStyles.textMain),
              ),
              content: const Text(
                "Cannot find surface to anchor object.",
                style: TextStyle(color: ColorStyles.textLight),
              ),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      ColorStyles.primary,
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: ColorStyles.textMain),
                  ),
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
            key: keyARView,
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          SafeArea(
            bottom: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_nodes.isNotEmpty)
                  Builder(
                    key: keyClearButton,
                    builder: (context) => Padding(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: ColorStyles.accent,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
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
                  ),
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Builder(
                          key: keySinglePanelButton,
                          builder: (context) =>
                              _buildNavButton('Single Panel', 0, isLeft: true),
                        ),
                        Builder(
                          key: keySampleLayoutButton,
                          builder: (context) => _buildNavButton(
                            'Sample Layout',
                            1,
                            isLeft: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                          color: Colors.black.withAlpha(10),
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
            color: isSelected
                ? ColorStyles.primary
                : ColorStyles.backgroundMain,
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
