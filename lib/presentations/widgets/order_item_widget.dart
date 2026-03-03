import 'package:epharmacy/core/utils/formatters.dart';
import 'package:epharmacy/data/models/cart_model.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  final CartModel item;
  const OrderItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.name ?? '',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Image.network(item.image ?? '', height: 30, width: 30),
      trailing: Text(
        AppFormatters.formatRupiah(item.price ?? 0),
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
