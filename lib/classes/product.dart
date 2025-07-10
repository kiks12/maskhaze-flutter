
import 'package:maskhaze_flutter/classes/product_type.dart';

class Product {
  final int id;
  final String name;
  final List<ProductType> types;

  Product({required this.id, required this.name, required this.types});
}