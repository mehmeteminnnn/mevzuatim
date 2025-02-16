import 'package:flutter/material.dart';
import 'package:mevzuatim/screens/deneme.dart';
import 'package:mevzuatim/screens/home_screen.dart';
//import 'mevzuat_screen.dart';
//import 'gtip_screen.dart';
import 'profile_screen.dart';
import 'package:mevzuatim/screens/mevzuat_search_screen.dart';
import 'package:mevzuatim/screens/gtip_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MevzuatScreen(),
    GtipScreen(),
    ProfileScreen(),
    BlogScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel),
            label: 'Mevzuat Ara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'GTİP Ara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search_rounded),
            label: 'Deneme',
          ),
        ],
      ),
    );
  }
}
