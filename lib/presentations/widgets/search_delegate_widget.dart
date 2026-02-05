import 'package:epharmacy/data/models/product_model.dart';
import 'package:epharmacy/presentations/cubits/product/product_cubit.dart';
import 'package:epharmacy/presentations/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchProducts extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Cari obat...';
  ProductModel? product;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.search),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
        context.read<ProductCubit>().getProducts();
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      context.read<ProductCubit>().searchProducts(query);
    }

    return ProductWidget();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      context.read<ProductCubit>().searchProducts(query);
    }

    if (query.isEmpty) {
      return SizedBox();
    }

    return ProductWidget();
  }
}
