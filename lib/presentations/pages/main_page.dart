import 'package:epharmacy/presentations/pages/cart_page.dart';
import 'package:epharmacy/presentations/pages/favorite_page.dart';
import 'package:epharmacy/presentations/pages/home_page.dart';
import 'package:epharmacy/presentations/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<dynamic> page = [
    const HomePage(),
    const FavoritePage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 30,
              color: Colors.blue,
            ),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.favorite : Icons.favorite_outline,
              size: 30,
              color: Colors.blue,
            ),
            label: "favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? Icons.shopping_bag
                  : Icons.shopping_bag_outlined,
              size: 30,
              color: Colors.blue,
            ),
            label: "cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline,
              size: 30,
              color: Colors.blue,
            ),
            label: "profile",
          ),
        ],
      ),
    );
  }
}
