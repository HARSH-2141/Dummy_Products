import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import 'package:dummy_page/models/product_model.dart' hide CartModel;
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Shopping Cart'),
            centerTitle: true,
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: cart.items.isEmpty
              ? _buildEmptyCartView(context)
              : _buildCartContent(context, cart),
        );
      },
    );
  }

  Widget _buildEmptyCartView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 120, color: Colors.grey[300]),
          const SizedBox(height: 24),
          const Text(
            'Your cart is feeling light!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            "Looks like you haven't added anything yet.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Start Shopping', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartModel cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final cartItem = cart.items[index];
              final product = cartItem.product;
              final quantity = cartItem.quantity;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          product.thumbnail,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Text(
                              'Price: ₹${product.price.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.green[700], fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline, color: Colors.red[400]),
                                      onPressed: () => cart.decreaseQuantity(product.id),
                                      tooltip: 'Decrease quantity',
                                    ),
                                    Text('$quantity',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline, color: Colors.green[400]),
                                      onPressed: () => cart.increaseQuantity(product.id),
                                      tooltip: 'Increase quantity',
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_forever, color: Colors.grey[600], size: 26),
                                  onPressed: () {
                                    cart.removeProductCompletely(product.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${product.title} removed from cart.')),
                                    );
                                  },
                                  tooltip: 'Remove item from cart',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // 🆕 Add Offers Button
        TextButton.icon(
          icon: const Icon(Icons.local_offer, color: Colors.deepPurpleAccent),
          label: const Text("Show Offers"),
          onPressed: () => _showOfferSheet(context),
        ),
        _buildCartSummary(context, cart),
      ],
    );
  }

  Widget _buildCartSummary(BuildContext context, CartModel cart) {
    final deliveryFee = cart.totalPrice > 0 ? 50.00 : 0.00;
    final total = cart.totalPrice + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Subtotal:', '₹${cart.totalPrice.toStringAsFixed(2)}', color: Colors.grey),
          const SizedBox(height: 10),
          _buildSummaryRow('Delivery Charges:', '₹${deliveryFee.toStringAsFixed(2)}', color: Colors.orange),
          const Divider(height: 25, thickness: 1.5),
          _buildSummaryRow('Total Payable:', '₹${total.toStringAsFixed(2)}',
              color: Colors.deepPurpleAccent, isBold: true, fontSize: 22),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (cart.items.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proceeding to secure checkout!'), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your cart is empty.'), backgroundColor: Colors.red),
                  );
                }
              },
              icon: const Icon(Icons.payment_outlined, size: 28),
              label: const Text('Proceed to Checkout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value,
      {Color? color, bool isBold = false, double fontSize = 18}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: fontSize, color: color ?? Colors.grey, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: fontSize, color: color ?? Colors.black87, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  void _showOfferSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Available Offers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.local_offer, color: Colors.green),
                title: Text("Get ₹50 off on orders above ₹499"),
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard, color: Colors.orange),
                title: Text("Free gift with orders over ₹999"),
              ),
              ListTile(
                leading: Icon(Icons.percent, color: Colors.deepPurpleAccent),
                title: Text("10% cashback on UPI payments"),
              ),
            ],
          ),
        );
      },
    );
  }
}
