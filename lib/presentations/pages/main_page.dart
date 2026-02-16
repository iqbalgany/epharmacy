import 'package:epharmacy/presentations/pages/cart/cart_page.dart';
import 'package:epharmacy/presentations/pages/product/home_page.dart';
import 'package:epharmacy/presentations/pages/settings/settings_page.dart';
import 'package:epharmacy/presentations/pages/wishlist/wishlist_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final int intialIndex;
  const MainPage({super.key, this.intialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.intialIndex;
  }

  List<Widget> page = [
    const HomePage(),
    const WishlistPage(),
    const CartPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black54,
          currentIndex: _selectedIndex,
          iconSize: 30,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              backgroundColor: Colors.white,
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Icons.favorite : Icons.favorite_outline,
              ),
              backgroundColor: Colors.white,
              label: "favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2
                    ? Icons.shopping_bag
                    : Icons.shopping_bag_outlined,
              ),
              backgroundColor: Colors.white,
              label: "cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? Icons.person : Icons.person_outline,
              ),
              backgroundColor: Colors.white,
              label: "profile",
            ),
          ],
        ),
      ),
    );
  }
}
