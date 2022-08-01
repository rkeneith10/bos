import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/list_eleves_screen.dart';
import '../screens/profil_screen.dart';
import '../screens/liste_course.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  List pages = [
    const HomeScreen(),
    const ListeCourse(),
    const ProfilScreen(),
  ];
  int currentIndex = 0;
  void onTap(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: currentIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 2,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: "Course", icon: Icon(Icons.car_rental)),
            BottomNavigationBarItem(label: "Profil", icon: Icon(Icons.person)),
          ]),
    );
  }
}
