import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/classes/product_type.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/classes/product.dart';
import 'package:maskhaze_flutter/data/images.dart';

class ProductCard extends StatefulWidget {
  final Product item;
  final VoidCallback? onPress;

  const ProductCard({
    super.key,
    required this.item,
    this.onPress,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int selectedPackIdx = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = (260.0 < screenWidth - 64) ? 260.0 : screenWidth - 64;
    
    final packs = widget.item.types;
    final selectedPack = packs[selectedPackIdx];

    return GestureDetector(
      onTap: widget.onPress,
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
            _buildNameAndPriceRow(selectedPack),
            const SizedBox(height: 10),
            
            // Packs Row
            _buildPacksRow(packs),
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
          images[widget.item.name] ?? 'assets/products/default.png',
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

  Widget _buildNameAndPriceRow(ProductType selectedPack) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product Name
        Expanded(
          child: Text(
            widget.item.name,
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
            '\$${selectedPack.price.toStringAsFixed(2)}',
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

  Widget _buildPacksRow(List<ProductType> packs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
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
      ),
    );
  }
}