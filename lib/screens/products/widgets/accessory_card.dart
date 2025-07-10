import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/classes/accessory.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/data/images.dart';

class AccessoryCard extends StatelessWidget {
  final Accessory item;
  final VoidCallback? onTap;

  const AccessoryCard({
    super.key,
    required this.item,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else {
      // Default navigation behavior
      Navigator.pushNamed(
        context,
        '/accessory-details',
        arguments: item,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = (260.0 < screenWidth - 64) ? 260.0 : screenWidth - 64;

    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Container
            _buildImageContainer(imageWidth),
            const SizedBox(height: 18),
            
            // Name and Price Row
            _buildNameAndPriceRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(double imageWidth) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          images[item.name] ?? 'assets/accessories/default.png',
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
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNameAndPriceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Accessory Name
        Expanded(
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ColorStyles.textMain,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(width: 8),
        
        // Price Container
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorStyles.primary,
            ),
          ),
        ),
      ],
    );
  }
}
