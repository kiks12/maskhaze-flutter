import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/screens/simulate_maskhaze/simulate_android_maskhaze_screen.dart';
import 'package:maskhaze_flutter/screens/simulate_maskhaze/simulate_ios2_maskhaze_screen.dart';

class Simulatemaskhazewrapper extends StatelessWidget {
  const Simulatemaskhazewrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const Simulateios2maskhazescreen();
    } else {
      return const Simulateandroidmaskhazescreen();
    }
  }
}