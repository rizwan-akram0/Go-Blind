import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/controllers/home_controller.dart';
import 'package:go_blind/views/compose_screen/compose_screen.dart';
import 'package:go_blind/views/home_screen/components/chat_component.dart';
import 'package:go_blind/views/profile_screen/profile_screen.dart';

Widget tabbarView() {
  // Get.put(HomeController());
  var controller = Get.find<HomeController>();
  return Expanded(
    child: Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: TabBarView(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
            ),
            child: chatsComponent(),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
              color: Colors.white,
            ),
            child: const ComposeScreen(
              isCompose: false,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
            ),
            child: InkWell(
              onTap: () {
                controller.isProfile.value = false;
              },
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
    ),
  );
}
