import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:front/models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 18),
      child: SizedBox(
        child: Material(
          type: MaterialType.card,
          elevation: 8,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5,),
              user.profilePictureId== null?const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('avatar.png')
              ):CircleAvatar(
                  radius: 60,
                  backgroundImage:  NetworkImage('http://localhost:8080/api/v1/file/${user.profilePictureId}')
              ),
              const SizedBox(height: 20),
              Text(
                user.fullName ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email ?? 'No email',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.contactNo ?? 'No contact number',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}