import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/classes/product.dart';
import 'package:maskhaze_flutter/classes/product_type.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/data/images.dart';
import 'package:maskhaze_flutter/screens/widgets/inquiry_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';


class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedPackIdx = 0;

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

  Future<void> _handleInquireSubmit(Map<String, String> fields) async {
    try {
      final name = fields['name'] ?? '';
      final email = fields['email'] ?? '';
      final message = fields['message'] ?? '';
      final selectedPack = widget.product.types[selectedPackIdx];
      
      const to = 'francistolentino1107@gmail.com';
      final subject = 'Inquiry about ${widget.product.name}';
      final body = 'Name: $name\nEmail: $email\nProduct: ${widget.product.name} (${selectedPack.packs} pack)\nMessage: $message';
      
      final uri = Uri(
        scheme: 'mailto',
        path: to,
        query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        throw 'Could not launch email client';
      }
    } catch (error) {
      debugPrint('Error sending email: $error');
      if (mounted) {
        _showErrorDialog();
      }
    }
  }

  void _showSuccessDialog() {
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

  void _showErrorDialog() {
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

  void _showInquiryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InquiryBottomSheet(
        title: 'Inquire about ${widget.product.name}',
        onSubmit: _handleInquireSubmit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = (320.0 < screenWidth - 48) ? 320.0 : screenWidth - 48;
    final packs = widget.product.types;
    final selectedPack = packs[selectedPackIdx];

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
                      // Product Image
                      _buildProductImage(imageWidth),
                      const SizedBox(height: 18),
                      
                      // Product Name and Price
                      _buildNameAndPrice(selectedPack),
                      
                      // Pack Selection
                      _buildPackSelection(packs),
                      const SizedBox(height: 12),
                      
                      // Action Buttons
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Floating Back Button
          _buildFloatingBackButton(),
        ],
      ),
    );
  }

  Widget _buildProductImage(double imageWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        images[widget.product.name] ?? 'assets/products/default.png',
        width: imageWidth,
        height: imageWidth,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: imageWidth,
            height: imageWidth,
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

  Widget _buildNameAndPrice(ProductType selectedPack) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: ColorStyles.textMain,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '\$${selectedPack.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorStyles.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPackSelection(List<ProductType> packs) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: packs.asMap().entries.map((entry) {
        final idx = entry.key;
        final type = entry.value;
        final isSelected = selectedPackIdx == idx;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPackIdx = idx;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? ColorStyles.primary 
                  : ColorStyles.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? ColorStyles.primary 
                    : ColorStyles.borderColor,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 16,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '${type.packs} pack${type.packs > 1 ? 's' : ''}',
              style: TextStyle(
                color: isSelected 
                    ? ColorStyles.white 
                    : ColorStyles.textMain,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
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
              onPressed: _showInquiryBottomSheet,
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

  Widget _buildFloatingBackButton() {
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
