import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialHelper {
  static const String _tutorialShownKey = 'tutorial_shown_';

  static Future<bool> hasTutorialBeenShown(String screenId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_tutorialShownKey + screenId) ?? false;
  }

  static Future<void> setTutorialShown(String screenId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialShownKey + screenId, true);
  }

  static void showTutorial({
    required BuildContext context,
    required List<TargetFocus> targets,
    required String screenId,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) async {
    print("DEBUG: TutorialHelper.showTutorial called for screenId: $screenId");
    bool tutorialShown = await hasTutorialBeenShown(screenId);
    print(
      "DEBUG: Tutorial for $screenId has been shown before: $tutorialShown",
    );

    if (!tutorialShown) {
      print("DEBUG: Showing tutorial for $screenId");
      TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () {
          setTutorialShown(screenId);
          onFinish?.call();
          print("DEBUG: Tutorial for $screenId finished.");
        },
        onSkip: () {
          setTutorialShown(screenId);
          onSkip?.call();
          print("DEBUG: Tutorial for $screenId skipped.");
          return false;
        },
      ).show(context: context);
    } else {
      print(
        "DEBUG: Tutorial for $screenId not shown because it was already seen.",
      );
    }
  }
}
