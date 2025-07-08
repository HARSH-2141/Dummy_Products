import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import '../screens/wishlist_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = 'Guest';
  String userEmail = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      isLoggedIn = user != null;
      userName = prefs.getString('userName') ?? (isLoggedIn ? user?.displayName ?? 'User' : 'Guest');
      userEmail = prefs.getString('userEmail') ?? (isLoggedIn ? user?.email ?? '' : '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '',
                style: const TextStyle(fontSize: 28, color: Colors.deepPurple),
              ),
            ),
            decoration: const BoxDecoration(color: Colors.deepPurple),
          ),

          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  WishlistScreen()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Offers'),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
          ),
          const ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact Us'),
          ),
          const Divider(),

          // 🌗 Theme Toggle
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: const Text("Dark Mode"),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),

          const Divider(),

          isLoggedIn
              ? ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await FirebaseAuth.instance.signOut();

              setState(() {
                userName = 'Guest';
                userEmail = '';
                isLoggedIn = false;
              });

              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          )
              : ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.of(context).pushNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
