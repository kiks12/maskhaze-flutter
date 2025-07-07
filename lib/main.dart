import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/ColorStyle.dart';
import 'package:maskhaze_flutter/screens/SimulateMaskhazeScreen.dart';
import 'package:maskhaze_flutter/screens/SimulateSRTMazeScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/ProductsScreen.dart';
import 'screens/ContactScreen.dart';

const widgetOptiosn = [
  HomeScreen(),
  Productsscreen(),
  Contactscreen(),
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/simulate-maskhaze': (context) => Simulatemaskhazescreen(),
        '/simulate-srtmaze': (context) => Simulatesrtmazescreen(),
      },
      color: ColorStyles.primary,
      home: Scaffold(
        body: widgetOptiosn[_selectedIndex],
        backgroundColor: ColorStyles.backgroundMain,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail),
              label: 'Contact',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorStyles.primary,
          unselectedItemColor: ColorStyles.textMuted,
          backgroundColor: ColorStyles.backgroundMain,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}