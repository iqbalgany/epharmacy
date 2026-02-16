import 'package:epharmacy/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WishlistLocalStorage {
  static const String boxName = 'products_box';
  static Future<void> openBox() async {
    await Hive.openBox<ProductModel>(boxName);
  }

  static Box<ProductModel> getBox() {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<ProductModel>(boxName);
    } else {
      throw Exception(
        'Box $boxName belum dibuka! Panggil openBox di main.dart',
      );
    }
  }

  static Future<void> closeBox() async {
    if (Hive.isBoxOpen(boxName)) {
      Hive.box(boxName).close();
    }
  }

  static Future<void> clearBox() async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<ProductModel>(boxName).clear();
    }
  }
}
