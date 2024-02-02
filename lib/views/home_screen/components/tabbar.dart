import 'package:flutter/material.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:velocity_x/velocity_x.dart';

Widget tabbar() {
  return const RotatedBox(
    quarterTurns: 3,
    child: TabBar(
      dividerHeight: 0,
      indicatorWeight: 0,
      labelColor: Colors.white,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelColor: Vx.gray500,
      indicator: BoxDecoration(),
      tabs: [
        Tab(
          text: chats,
        ),
        Tab(
          text: friends,
        ),
        Tab(
          text: profile,
        ),
      ],
    ),
  );
}
