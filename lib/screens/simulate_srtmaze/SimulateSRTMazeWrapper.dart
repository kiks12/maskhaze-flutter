
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/screens/simulate_srtmaze/SimulateAndroidSRTMazeScreen.dart';
import 'package:maskhaze_flutter/screens/simulate_srtmaze/SimulateIosSRTMazeScreen.dart';

class Simulatesrtmazewrapper extends StatelessWidget {
  const Simulatesrtmazewrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const SimulateIOSsrtmazescreen();
    } else {
      return const Simulateandroidsrtmazescreen();
    }
  }
}