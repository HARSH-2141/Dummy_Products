import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart' hide CartModel;
import '../services/api_service.dart';
import '../models/cart_model.dart';
import '../models/wishlist_model.dart';
import 'product_detail_screen.dart';

class ProductListScreenV2 extends StatefulWidget {
  final String category;

  ProductListScreenV2({required this.category});

  @override
  _ProductListScreenV2State createState() => _ProductListScreenV2State();
}

class _ProductListScreenV2State extends State<ProductListScreenV2> {
  List<Product> _products = [];
  List<Product> _filtered = [];
  String _searchQuery = '';
  String _sortBy = 'None';
  bool _showGrid = true;
  bool _onlyInStock = false;

  double _minPrice = 0;
  double _maxPrice = 100000;
  double _minRating = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final products = await ApiService.fetchProductsByCategory(widget.category);
    setState(() {
      _products = products;
      _filtered = products;
    });
  }

  void _applyFilters() {
    List<Product> filtered = _products.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStock = !_onlyInStock || p.stock > 0;
      final matchesPrice = p.price >= _minPrice && p.price <= _maxPrice;
      final matchesRating = p.rating >= _minRating;
      return matchesSearch && matchesStock && matchesPrice && matchesRating;
    }).toList();

    switch (_sortBy) {
      case 'Price ↑':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price ↓':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating ↓':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    setState(() {
      _filtered = filtered;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text("Filter Products", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("In Stock Only"),
                    Switch(
                      value: _onlyInStock,
                      onChanged: (val) {
                        setSheetState(() => _onlyInStock = val);
                      },
                    )
                  ],
                ),
                const Text("Price Range"),
                RangeSlider(
                  values: RangeValues(_minPrice, _maxPrice),
                  min: 0,
                  max: 100000,
                  divisions: 20,
                  labels: RangeLabels('${_minPrice.toInt()}', '${_maxPrice.toInt()}'),
                  onChanged: (range) {
                    setSheetState(() {
                      _minPrice = range.start;
                      _maxPrice = range.end;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Text("Minimum Rating"),
                Slider(
                  value: _minRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _minRating.toStringAsFixed(1),
                  onChanged: (value) {
                    setSheetState(() => _minRating = value);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: const Text("Apply Filters"),
                )
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Text("Products - ${widget.category}",style: TextStyle(color: Colors.white,),),
        actions: [
          IconButton(
            icon: Icon(_showGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _showGrid = !_showGrid),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                    _applyFilters();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _sortBy,
                items: ['None', 'Price ↑', 'Price ↓', 'Rating ↓']
                    .map((e) => DropdownMenuItem(value: e, child: Text("Sort by $e")))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _sortBy = val;
                      _applyFilters();
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text("No products found."))
                  : _showGrid
                  ? GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (_, index) {
                  final p = _filtered[index];
                  return ProductCard(p: p, cart: cart);
                },
              )
                  : ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (_, index) {
                  final p = _filtered[index];
                  return ProductCard(p: p, cart: cart);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product p;
  final CartModel cart;

  const ProductCard({super.key, required this.p, required this.cart});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistModel>(context);
    final isLiked = wishlist.likedProducts.contains(p);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: p),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      p.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        if (isLiked) {
                          wishlist.removeProduct(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Removed from Wishlist")),
                          );
                        } else {
                          wishlist.addProduct(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to Wishlist")),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("₹${p.price}  ⭐ ${p.rating}"),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () => cart.addItem(p),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text("Stock: ${p.stock > 0 ? p.stock : 'Out'}"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
