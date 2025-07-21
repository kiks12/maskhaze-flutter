import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/screens/simulate_maskhaze/simulate_maskhaze_wrapper_screen.dart';
import 'package:maskhaze_flutter/screens/simulate_srtmaze/simulate_srtmaze_wrapper_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products/products_screen.dart';
import 'screens/contact_screen.dart';

const widgetOptiosn = [
  HomeScreen(),
  Productsscreen(),
  ContactScreen(),
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
        '/simulate-maskhaze': (context) => Simulatemaskhazewrapper(),
        '/simulate-srtmaze': (context) => Simulatesrtmazewrapper(),
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