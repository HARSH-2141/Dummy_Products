import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/OrderModel.dart';
import '../models/cart_model.dart';
import 'my_orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'UPI';
  String selectedAddress = 'Home Address, 221B Baker Street';

  final List<String> paymentMethods = ['UPI', 'Credit Card', 'Cash on Delivery'];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context); // ✅ CartModel
    final subtotal = cart.totalPrice;             // ✅ Dynamic subtotal
    double delivery = 50.00;
    double total = subtotal + delivery;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: const Text("Checkout",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🏠 Address Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: const Text("Shipping Address"),
                subtitle: Text(selectedAddress),
                trailing: const Icon(Icons.edit_location_alt),
                onTap: () {
                  // Replace with address selector logic
                  setState(() {
                    selectedAddress = 'Work Address, Tower A, Tech Park';
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // 💳 Payment Method
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...paymentMethods.map((method) => RadioListTile(
                      title: Text(method),
                      value: method,
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                    )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📦 Order Summary
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Order Summary",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
                    _buildPriceRow("Delivery Charges", "₹${delivery.toStringAsFixed(2)}", color: Colors.deepOrange),
                    const Divider(),
                    _buildPriceRow("Total Payable", "₹${total.toStringAsFixed(2)}",
                        isBold: true, color: Colors.purple),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Checkout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.check_circle_outline, color: Colors.white,),
                label: const Text(
                  "Place Order",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                  onPressed: () {
                    final cart = Provider.of<CartModel>(context, listen: false);
                    final orderModel = Provider.of<OrderModel>(context, listen: false);

                    // Save the current cart items as an order
                    final orderedProducts = cart.items.map((item) => item.product).toList();
                    orderModel.placeOrder(orderedProducts);

                    cart.clearCart(); // Optional: Clear the cart after placing order

                    // Show success message then navigate
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order placed successfully!")),
                    );

                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                      );
                    });
                  },

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              )),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
