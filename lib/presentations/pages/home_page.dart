import 'package:epharmacy/presentations/widgets/category_widget.dart';
import 'package:epharmacy/presentations/widgets/product_widget.dart';
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
              color: Colors.white,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.07,
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
            SizedBox(height: 16),
            CategoryWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: ProductWidget()),
          ],
        ),
      ),
    );
  }
}
