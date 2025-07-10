import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maskhaze_flutter/color_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void handleSimulateMaskhaze() {
    Navigator.pushNamed(context, '/simulate-maskhaze');
  }

  void handleSimulateSRTMaze() {
    Navigator.pushNamed(context, '/simulate-srtmaze');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/misc/appbg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorStyles.overlay,
                    ColorStyles.overlayDark,
                    ColorStyles.overlayDark,
                  ],
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Section
                    _buildHeaderSection(),
                    const SizedBox(height: 48),
                    // Action Card
                    _buildActionCard(screenSize),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                'assets/logo/mhlogo.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Welcome Title
        Text(
          'Welcome to MaskHaze',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.8),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          'Realistic Training, When real life matters',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFFDC2626),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Description
        Text(
          'Choose a simulation to begin',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionCard(Size screenSize) {
    return Container(
      width: screenSize.width - 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Primary Button - Simulate Maskhaze
          _buildPrimaryButton(),
          const SizedBox(height: 16),
          // Secondary Button - Simulate SRTMaze
          _buildSecondaryButton(),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: handleSimulateMaskhaze,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Simulate Maskhaze',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: handleSimulateSRTMaze,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1F2937), Color(0xFF111827)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.view_in_ar,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Simulate SRTMaze',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}