import 'package:flutter/material.dart';
import 'package:shimmer/main.dart';
import '../main.dart';
import 'login_screen.dart'; // Import MyApp to access theme toggle

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // --- Account Section ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.blue),
            title: const Text('Privacy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.green),
            title: const Text('Security'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.orange),
            title: const Text('Account Info'),
            onTap: () {},
          ),

          const Divider(),

          // --- Preferences Section ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none, color: Colors.red),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.teal),
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {},
          ),


          const Divider(),

          // --- App Info ---
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Rate Us'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
              // Add logout logic here
            },
          ),

          const SizedBox(height: 10),
          const Center(
            child: Text(
              'App version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
