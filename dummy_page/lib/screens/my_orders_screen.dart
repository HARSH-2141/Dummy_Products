// lib/screens/my_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/OrderModel.dart';
import '../models/product_model.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderModel = Provider.of<OrderModel>(context);
    final orders = orderModel.orders;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white,),
        title: const Text("My Orders",style: TextStyle(color: Colors.white,),),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? const Center(child: Text("No orders placed yet."))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order #${index + 1}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...order.map((product) => ListTile(
                    leading: Image.network(product.thumbnail, width: 50),
                    title: Text(product.title),
                    subtitle: Text("₹${product.price}"),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
