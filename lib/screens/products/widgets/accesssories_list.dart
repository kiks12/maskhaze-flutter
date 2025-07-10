
import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/classes/accessory.dart';
import 'package:maskhaze_flutter/data/accessories_data.dart';
import 'package:maskhaze_flutter/screens/products/accessory_details_screen.dart';
import 'package:maskhaze_flutter/screens/products/widgets/accessory_card.dart';

class AccesssoriesList extends StatefulWidget {
  const AccesssoriesList({super.key});

  @override
  State<AccesssoriesList> createState() => _AccesssoriesListState();
}

class _AccesssoriesListState extends State<AccesssoriesList> {

  void navigateToAccessoryDetailScreen(Accessory accessory) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccessoryDetailsScreen(accessory: accessory),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: accessoriesProducts.map((accessory) => AccessoryCard(item: accessory, onTap: () => navigateToAccessoryDetailScreen(accessory),)).toList(),
    );
  }
}