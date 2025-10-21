import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/MainLayout.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Profile',
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF1A56DB).withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF1A56DB),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A56DB),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    icon: Icons.shopping_bag,
                    label: 'My Orders',
                    onTap: () => Navigator.pushNamed(context, '/orders'),
                  ),
                  _buildProfileOption(
                    icon: Icons.history,
                    label: 'Order History',
                    onTap: () => Navigator.pushNamed(context, '/order-history'),
                  ),
                  _buildProfileOption(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings coming soon...'),
                        ),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1A56DB)),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
