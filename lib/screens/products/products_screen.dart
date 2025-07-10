
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/screens/products/accessories_products_screen.dart';
import 'package:maskhaze_flutter/screens/products/maskhaze_products_screen.dart';
import 'package:maskhaze_flutter/screens/products/srtmaze_products_screen.dart';

class Productsscreen extends StatelessWidget {
  const Productsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ColorStyles.backgroundMain,
        appBar: AppBar(
          backgroundColor: ColorStyles.backgroundMain,
          foregroundColor: ColorStyles.primary,
          automaticallyImplyLeading: false,
          title: const Text('Products', style: TextStyle(color: ColorStyles.textMain)),
          bottom: const TabBar(
            labelColor: ColorStyles.primary,
            indicatorColor: ColorStyles.primary,
            dividerColor: ColorStyles.borderColor,
            unselectedLabelColor: ColorStyles.textMuted,
            tabs: [
              Tab(text: 'MaskHaze'),
              Tab(text: 'SRTMaze'),
              Tab(text: 'Accessories'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MaskHazeProductsScreen(),
            SRTMazeProductsScreen(),
            AccessoriesProductsScreen(),
          ],
        ),
      ),
    );
  }
}


