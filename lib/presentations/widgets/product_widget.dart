import 'package:cached_network_image/cached_network_image.dart';
import 'package:epharmacy/constants/helpers.dart';
import 'package:epharmacy/presentations/cubits/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state.status == ProductStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state.status == ProductStatus.error) {
          return Center(child: Text(state.errorMessage));
        }
        return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
          ),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(20),
              ),
              elevation: 1,
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: getOptimizedUrl(
                            product.image,
                            MediaQuery.sizeOf(context).width.toInt(),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        product.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Rp${product.price}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
