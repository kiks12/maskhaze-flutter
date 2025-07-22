import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidCameraView extends StatelessWidget {
  const AndroidCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'camera_platform_view',
      layoutDirection: TextDirection.ltr,
      creationParams: {},
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
