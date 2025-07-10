
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/classes/accessory.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/data/images.dart';
import 'package:maskhaze_flutter/screens/widgets/inquiry_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class AccessoryDetailsScreen extends StatelessWidget {
  final Accessory accessory;

  const AccessoryDetailsScreen({
    super.key,
    required this.accessory,
  });


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

  Future<void> _handleInquireSubmit(BuildContext context, Map<String, String> fields) async {
    try {
      final name = fields['name'] ?? '';
      final email = fields['email'] ?? '';
      final message = fields['message'] ?? '';
      
      const to = 'francistolentino1107@gmail.com';
      final subject = 'Inquiry about ${accessory.name}';
      final body = 'Name: $name\nEmail: $email\nAccessory: ${accessory.name}\nMessage: $message';
      
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
          content: const Text('Unable to open your email app.'),
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
        title: 'Inquire about ${accessory.name}',
        onSubmit: (fields) => _handleInquireSubmit(context, fields),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundMain,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: ColorStyles.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Accessory Image
                      _buildAccessoryImage(),
                      const SizedBox(height: 18),
                      
                      // Accessory Name
                      Text(
                        accessory.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: ColorStyles.textMain,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      
                      // Price
                      Text(
                        '\$${accessory.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorStyles.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Floating Back Button
          _buildFloatingBackButton(context),
        ],
      ),
    );
  }

  Widget _buildAccessoryImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        images[accessory.name] ?? 'assets/accessories/default.png',
        width: 220,
        height: 220,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: ColorStyles.cardAlt,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: ColorStyles.textMuted,
              size: 64,
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 50),
      child: Column(
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
                  horizontal: 32,
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
                  horizontal: 32,
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
    );
  }

  Widget _buildFloatingBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorStyles.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.black.withOpacity(0.15),
                offset: const Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 28,
            color: ColorStyles.textMain,
          ),
        ),
      ),
    );
  }
}
