
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/classes/product.dart';
import 'package:maskhaze_flutter/data/maskhaze_data.dart';
import 'package:maskhaze_flutter/screens/products/product_details_screen.dart';
import 'package:maskhaze_flutter/screens/products/widgets/product_card.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {

  void navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: maskhazeProducts.map((product) => ProductCard(item: product, onPress: () => navigateToProductDetails(product))).toList(),
    );
  }
}