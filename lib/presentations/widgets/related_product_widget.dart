import 'package:cached_network_image/cached_network_image.dart';
import 'package:epharmacy/constants/helpers.dart';
import 'package:epharmacy/presentations/cubits/product/product_cubit.dart';
import 'package:epharmacy/presentations/pages/product/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedProductWidget extends StatefulWidget {
  final String categoryName;
  const RelatedProductWidget({super.key, required this.categoryName});

  @override
  State<RelatedProductWidget> createState() => _RelatedProductWidgetState();
}

class _RelatedProductWidgetState extends State<RelatedProductWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          return Center(child: Text(state.errorMessage));
        }

        if (state.status == ProductStatus.loading) {
          Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.35,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: state.products.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  elevation: 1,
                  child: Container(
                    height: 200,
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
                              imageUrl: Helpers.getOptimizedUrl(
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
                          'Rp${product.oldPrice}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.blue,
                            decorationThickness: 2.5,
                          ),
                        ),
                        Text(
                          'Rp${product.price}',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
