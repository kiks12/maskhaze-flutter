
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/ColorStyle.dart';

class Simulateandroidsrtmazescreen extends StatefulWidget {
  const Simulateandroidsrtmazescreen({super.key});

  @override
  State<Simulateandroidsrtmazescreen> createState() => _SimulateandroidsrtmazescreenState();
}

class _SimulateandroidsrtmazescreenState extends State<Simulateandroidsrtmazescreen> {
  late ArCoreController arCoreController;
  final List<String> _nodeNames = [];
  int _selectedModel = 0; // 0: Single Panel, 1: Sample Layout

  @override
  void initState() {
    super.initState();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enablePlaneRenderer: true,
            type: ArCoreViewType.STANDARDVIEW,
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
                          onTap: () {},
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
}