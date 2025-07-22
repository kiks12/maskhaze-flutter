import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IOSCameraView extends StatelessWidget {
  const IOSCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return const Text('iOS only');
    }

    return const UiKitView(
      viewType: 'native_camera_view',
      creationParams: <String, dynamic>{},
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
