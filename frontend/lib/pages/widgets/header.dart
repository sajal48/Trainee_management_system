import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:front/pages/widgets/profile.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';


class Header extends StatelessWidget {
  const Header({super.key});

  Widget _buildModalContent(BuildContext context,User user) {
    return ProfileWidget(user: user);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 30),
            Image.asset(
              'bjit_logo.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 10),
            const Text(
              'Evaluation Management System',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Consumer<AppController>(
            builder: (context, appController,_) {
              if(appController.userLoaded){
              return Container(
                child: PopupMenuButton<String>(
                  offset: Offset(-20,60),
                  onSelected: (value) {
                    if (value == 'view_profile') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: _buildModalContent(context,appController.user),
                          );
                        },
                      );

                    } else if (value == 'logout') {
                      Provider.of<AuthController>(context,listen: false).logOut(context);

                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'view_profile',
                      child: Text('View Profile'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ],
                  child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child:appController.user.profilePictureId== null ? const CircleAvatar(
                          backgroundImage:AssetImage('avatar.png'), // Replace with the actual image path.
                          radius: 25,
                        ):CircleAvatar(
                          backgroundImage:NetworkImage(
                              'http://localhost:8080/api/v1/file/${appController.user.profilePictureId}'
                          ), // Replace with the actual image path.
                          radius: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              );}else
              {
                return const SizedBox(
                  height: 30,
                    width: 30,
                    child: Center(child: CircularProgressIndicator(),));
              }
            }
          ),
        ),
      ],
    );
  }
}
