import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/controllers/home_controller.dart';
import 'package:go_blind/views/compose_screen/compose_screen.dart';
import 'package:go_blind/views/home_screen/components/appbar.dart';
import 'package:go_blind/views/home_screen/components/drawer.dart';
import 'package:go_blind/views/home_screen/components/tabbar.dart';
import 'package:go_blind/views/home_screen/components/tabbarview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    //init home controller
    var controller = Get.put(HomeController());
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: scaffoldKey,
          drawer: drawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const ComposeScreen(),
                  transition: Transition.downToUp);
            },
            backgroundColor: bgColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          backgroundColor: bgColor,
          body: Column(
            children: [
              controller.isProfile.value ? appbar(scaffoldKey) : Container(),
              Expanded(
                child: Row(
                  children: [
                    tabbar(),
                    tabbarView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
