import 'package:flutter/material.dart';
import 'package:project_tcc_agend/screnns/available_screen.dart';
import 'package:project_tcc_agend/screnns/home_screen_med.dart';
import 'package:project_tcc_agend/screnns/settings_screen.dart';

class NavBarRoots_Med extends StatefulWidget {
  @override
  State<NavBarRoots_Med> createState() => _NavBarRoots_MedState();
}

class _NavBarRoots_MedState extends State<NavBarRoots_Med> {
  int _selectedIndex = 0;
  final _screens = [
    HomeScreenMed(),
    EventApp(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color.fromARGB(255, 29, 6, 229),
            unselectedItemColor: Colors.black26,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Disponibilzar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Configurações",
              ),
            ]),
      ),
    );
  }
}
