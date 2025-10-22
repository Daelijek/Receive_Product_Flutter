import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/MainLayout.dart';
import 'package:flutter_application_1/widgets/Profile/ProfileHeader.dart';
import 'package:flutter_application_1/widgets/Profile/ProfileOption.dart';
import 'package:flutter_application_1/services/ApiService.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = ApiService.getCurrentUsername() ?? 'Guest';

    return MainLayout(
      title: 'Profile',
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileHeader(name: username, email: ''),
            Expanded(
              child: ListView(
                children: [
                  ProfileOption(
                    icon: Icons.shopping_bag,
                    label: 'My Orders',
                    onTap: () => Navigator.pushNamed(context, '/orders'),
                  ),
                  ProfileOption(
                    icon: Icons.history,
                    label: 'Order History',
                    onTap: () => Navigator.pushNamed(context, '/order-history'),
                  ),
                  ProfileOption(
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
}
