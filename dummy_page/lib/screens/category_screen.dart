import 'dart:async';
import 'package:dummy_page/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import 'product_list_screen_v2.dart';
import '../widgets/app_drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String getCategoryImage(String slug) {
    switch (slug) {
      case 'smartphones':
        return 'https://img.freepik.com/free-photo/elegant-smartphone-composition_23-2149437106.jpg?semt=ais_hybrid&w=740';

      case 'sports-accessories':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6ne2XOeE6QQZ0fG7VlAWONduWF-8mQQxfcA&s';
      case 'mobile-accessories':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWqQHbnOn6DKExFwWGvWaFCQTHTaYDV_zlhQ&s';
      case 'kitchen-accessories':
        return 'https://assets.architecturaldigest.in/photos/6045cf4607b8c2a9c90a31cc/16:9/w_1920,h_1080,c_limit/modular-kitchen-accessories-design-interiors.jpg';
      case 'beauty':
        return 'https://media.istockphoto.com/id/493029628/photo/set-of-decorative-cosmetic.jpg?s=612x612&w=0&k=20&c=JYxqtgYkpBD-tITJJ60ex_04bEi52uHCEJDFuOlKaNA=';
      case 'vehicle':
        return 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y2FyfGVufDB8fDB8fHww';
      case 'tablets':
        return 'https://images.indianexpress.com/2024/06/Lenovo-Tab-Plus.jpeg';
      case 'laptops':
        return 'https://cdn.thewirecutter.com/wp-content/media/2024/07/laptopstopicpage-2048px-3685-2x1-1.jpg?width=2048&quality=75&crop=2:1&auto=webp';
      case 'fragrances':
        return 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cGVyZnVtZXN8ZW58MHx8MHx8fDA%3D';
      case 'skin-care':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfoy1NNN7XrebuR0NkOi_ZKoQsclZoijppJQ&s';
      case 'groceries':
        return 'https://miro.medium.com/v2/resize:fit:1200/1*mo0myR6C7krWTipKq_rJ4A.jpeg';
      case 'home-decoration':
        return 'https://www.centuryply.com/assets/img/blog/25-08-22/blog-home-decoration-3.jpg';
      case 'furniture':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0RrrrjVlgp63KiDZAQNITCXqDnsmutmqQsQ&s';
      case 'tops':
        return 'https://images-cdn.ubuy.co.in/660ca46a3ca7d70bac0d182a-htnbo-cute-crop-tops-for-women-summer.jpg';
      case 'womens-dresses':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPs6kv22b4KoDHzouNMGgmpgKsoU5LOANp5w&s';
      case 'womens-shoes':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnQXznWbLi9QJdFHkTd7IsXS5CFADsYRR2LQ&s';
      case 'mens-shirts':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdUe9Fzx_wKOMEJ7aPaMytVq4nDOoeLhlk7w&s';
      case 'mens-shoes':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqOyykmvIWTzZjTIiZ8nVeXkxWTjPw_0tdRw&s';
      case 'mens-watches':
        return 'https://blog.luxehouze.com/wp-content/uploads/2024/06/1-10-scaled.jpg';
      case 'womens-watches':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-efS9wqLgA0p2IGFoNApiTWVtvD3zg4gcOg&s';
      case 'womens-bags':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeI7eYZoO5K3z9R1mO_CJbm1YiL3Q1eFvw-w&s';
      case 'womens-jewellery':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeI7eYZoO5K3z9R1mO_CJbm1YiL3Q1eFvw-w&s';
      case 'sunglasses':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBKCG_qRs-EHO3ttnyPcz827vTwRF6zuEmfw&s';
      case 'automotive':
        return 'https://img.freepik.com/premium-vector/automotive-car-vector-logo-template_278810-496.jpg';
      case 'motorcycle':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhDPKU_xSuB7JekO9ycEbvmmCpRGK84nuJcg&s';
      case 'lighting':
        return 'https://assets.andrewmartin.co.uk/cdn-cgi/image/fit=crop%2Cformat=auto%2Cquality=75%2Cwidth=1220%2Cheight=813%2Ctrim=0%3B1197%3B0%3B1196/images/original/19454-lighting-studio-2.jpg';
      default:
        return 'https://via.placeholder.com/100x100.png?text=Image';
    }
  }

  int _selectedIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _sliderTimer;

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();

  final List<String> _sliderImages = [
    'https://img.freepik.com/free-photo/futuristic-smartphone-composition_23-2149437104.jpg',
    'https://cdn.thewirecutter.com/wp-content/media/2024/07/laptopstopicpage-2048px-3685-2x1-1.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBKCG_qRs-EHO3ttnyPcz827vTwRF6zuEmfw&s',
    'https://t3.ftcdn.net/jpg/05/07/79/68/360_F_507796863_XOctjfN6VIiHa79bFj7GCg92P9TpELIe.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchController.addListener(_filterCategories);
    _startSliderAutoScroll();
  }

  void _startSliderAutoScroll() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= _sliderImages.length) _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),

          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _loadCategories() async {
    final categories = await ApiService.fetchCategories();
    setState(() {
      _allCategories = categories;
      _filteredCategories = categories;
    });
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories
          .where((cat) => cat.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WishlistScreen()),
        );
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sliderTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const AppDrawer(


      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white,),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text('Dummy Products',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white,),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          PopupMenuButton<String>(
            offset: const Offset(0, kToolbarHeight), // Makes the menu appear below the AppBar icon, not below the AppBar itself
            icon: const Icon(Icons.more_vert,color: Colors.white,),
            onSelected: (value) {
              switch (value) {
                case 'share':
                // Add your share logic
                  break;
                case 'invite':
                // Add your invite logic
                  break;
                case 'feedback':
                // Navigate or show dialog for feedback
                  break;
                case 'theme':
                // Open theme selection or toggle
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share, color: Colors.blue),
                  title: Text("Share App"),
                ),
              ),
              const PopupMenuItem(
                value: 'invite',
                child: ListTile(
                  leading: Icon(Icons.group_add, color: Colors.green),
                  title: Text("Invite Friends"),
                ),
              ),
              const PopupMenuItem(
                value: 'feedback',
                child: ListTile(
                  leading: Icon(Icons.feedback_outlined, color: Colors.orange),
                  title: Text("Send Feedback"),
                ),
              ),
              const PopupMenuItem(
                value: 'theme',
                child: ListTile(
                  leading: Icon(Icons.palette, color: Colors.purple),
                  title: Text("Change Theme"),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar stays fixed
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),

          // 🔁 Slider + Categories in scrollable area
          Expanded(
            child: ListView(
              children: [
                // 🔁 Image slider (styled)
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _sliderImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Image.network(
                                _sliderImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // 📦 Category Grid
                if (_filteredCategories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: Text("No categories found.")),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3, // ✅ Show 3 per row
                      shrinkWrap: true,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: _filteredCategories.map((category) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 400),
                                child: ProductListScreenV2(
                                  category: category.slug,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade100,
                                  Colors.pinkAccent.shade100,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    getCategoryImage(category.slug),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.deepPurple,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
