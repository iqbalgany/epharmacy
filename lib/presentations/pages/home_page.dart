import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Card(
              elevation: 1,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.99,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black,
                    ),
                    suffixIcon: Icon(Icons.tune),
                    hintText: 'Search Product',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                    contentPadding: EdgeInsets.only(top: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
