import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/screens/widgets/inquiry_bottom_sheet.dart';

class SRTMazeProductsScreen extends StatelessWidget {
  const SRTMazeProductsScreen({super.key});

  Future<void> _handleOrder() async {
    const url = 'https://maskhaze.com/shop-1';
    final uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  Future<void> _handleInquire(BuildContext context, Map<String, String> fields) async {
    try {
      final name = fields['name'] ?? '';
      final email = fields['email'] ?? '';
      final message = fields['message'] ?? '';
      
      const to = 'francistolentino1107@gmail.com';
      const subject = 'SRT Maze Inquiry';
      final body = 'Name: $name\nEmail: $email\nMessage: $message';
      
      final uri = Uri(
        scheme: 'mailto',
        path: to,
        query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        if (context.mounted) {
          _showSuccessDialog(context);
        }
      } else {
        throw 'Could not launch email client';
      }
    } catch (error) {
      debugPrint('Error sending email: $error');
      if (context.mounted) {
        _showErrorDialog(context);
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inquiry'),
          content: const Text('Thank you for your inquiry! Please send the email in your mail app.'),
          backgroundColor: ColorStyles.cardBackground,
          titleTextStyle: ColorStyles.textLightStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: ColorStyles.textStyle,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: ColorStyles.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Unable to open your email app. Please try again on a real device.'),
          backgroundColor: ColorStyles.cardBackground,
          titleTextStyle: ColorStyles.textLightStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: ColorStyles.textStyle,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: ColorStyles.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInquiryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InquiryBottomSheet(
        title: 'Inquire about SRT Maze',
        onSubmit: (fields) => _handleInquire(context, fields),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorStyles.backgroundMain,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(28),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Product Image
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/products/mazeproduct.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: ColorStyles.cardAlt,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: ColorStyles.textMuted,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Title
                Text(
                  'SRT Maze',
                  style: ColorStyles.textStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                
                // Subtitle
                Text(
                  'A quick setup modular fire and rescue training system designed for rapid deployment and realistic, scenario-based skill practice.',
                  style: ColorStyles.textStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                
                // Buttons
                Column(
                  children: [
                    // Primary Button - Order
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyles.primary,
                          foregroundColor: ColorStyles.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 28,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Order',
                          style: ColorStyles.whiteTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Secondary Button - Inquire
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showInquiryBottomSheet(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: ColorStyles.white,
                          foregroundColor: ColorStyles.primary,
                          side: const BorderSide(
                            color: ColorStyles.primary,
                            width: 1,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 28,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Inquire',
                          style: ColorStyles.primaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
