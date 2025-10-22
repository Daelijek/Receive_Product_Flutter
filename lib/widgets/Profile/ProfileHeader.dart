import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFF1A56DB).withOpacity(0.1),
          child: const Icon(Icons.person, size: 60, color: Color(0xFF1A56DB)),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A56DB),
          ),
        ),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        const SizedBox(height: 30),
      ],
    );
  }
}