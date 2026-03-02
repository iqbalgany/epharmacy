import 'package:epharmacy/presentations/cubits/order/order_cubit.dart';
import 'package:epharmacy/presentations/widgets/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Orders'), elevation: 0),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, orderState) {
          if (orderState.status == OrderStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (orderState.orders.isEmpty) {
            return Center(child: Text('You have no orders yet.'));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: orderState.orders.length,
            itemBuilder: (context, index) {
              final order = orderState.orders[index];
              return Padding(
                padding: EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ExpansionTile(
                              title: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order Id',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          order.orderId,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          DateFormat.yMMM().format(order.date),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '\$${order.total}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              children: [
                                Column(
                                  children: order.products
                                      .map(
                                        (item) => OrderItemWidget(item: item),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (order.isAccepted == true &&
                        order.isCancelled == false &&
                        order.isDelivered == false) ...{
                      Positioned(
                        top: 2,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text('Accepted'),
                        ),
                      ),
                    } else if (order.isAccepted == true &&
                        order.isDelivered == true) ...{
                      Positioned(
                        top: 2,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text('Delivered'),
                        ),
                      ),
                    } else if (order.isCancelled == true) ...{
                      Positioned(
                        top: 2,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text('Canceled'),
                        ),
                      ),
                    } else if (order.isCancelled == false &&
                        order.isAccepted == false &&
                        order.isDelivered == false) ...{
                      Positioned(
                        top: 2,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text('isPending'),
                        ),
                      ),
                    },
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
