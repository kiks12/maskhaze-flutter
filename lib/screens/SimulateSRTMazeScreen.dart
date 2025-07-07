
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class Simulatesrtmazescreen extends StatefulWidget {
  const Simulatesrtmazescreen({super.key});

  @override
  State<Simulatesrtmazescreen> createState() => _SimulatesrtmazescreenState();
}

class _SimulatesrtmazescreenState extends State<Simulatesrtmazescreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager? arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
    );
    this.arObjectManager!.onInitialize();
    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
  }

  Future<File> _loadGLBModelToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer;

    final tempDir = await getTemporaryDirectory(); // safer on iOS
    final filePath = '${tempDir.path}/${assetPath.split("/").last}';

    final file = await File(filePath).writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    final exists = await file.exists();
    final size = await file.length();
    print("✅ File written to: $filePath");
    print("📦 Exists: $exists, Size: $size bytes");


    print('File path: $filePath');
    return file;
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (hitTestResults.isEmpty) return;
    final hit = hitTestResults.first;
    // Add anchor at the tapped point
    final newAnchor = ARPlaneAnchor(transformation: hit.worldTransform);
    final success = await arAnchorManager?.addAnchor(newAnchor);
    if (success == true) {
      anchors.add(newAnchor);
      // Copy model to temp dir and get file URI
      final modelUri = await _loadGLBModelToFile('assets/models/SampleLayout.glb');
      if (!await modelUri.exists()) {
        print("❌ ERROR: File does not exist at ${modelUri.path}");
        return;
      } else {
        print("✅ File exists at ${modelUri.path}");
      }
      // Add the 3D model to the anchor
      final node = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: Uri.file(modelUri.path).toString(),
        scale: Vector3(0.5, 0.5, 0.5),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(0.0, 0.0, 0.0, 0.0),
      );
      await arObjectManager?.addNode(node, planeAnchor: newAnchor);
      setState(() {});
    }
  }
}