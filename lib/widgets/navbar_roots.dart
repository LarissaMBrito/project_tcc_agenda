import 'package:flutter/material.dart';
import 'package:project_tcc_agend/screnns/home_screen.dart';
import 'package:project_tcc_agend/screnns/schedule_screen.dart';
import 'package:project_tcc_agend/screnns/settings_screen.dart';

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    HomeScreen(),
    ScheduleScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      backgroundColor: Colors.white,
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
                label: "Calendário",
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
