import 'package:flutter/material.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:velocity_x/velocity_x.dart';

Widget statusComponent() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: btnColor,
            child: Image.asset(ic_user, color: Colors.white),
          ),
          title: "My status".text.fontFamily(semibold).color(txtColor).make(),
          subtitle: "Tap to add status update".text.gray400.make(),
        ),
        20.heightBox,
        recentUpdates.text.fontFamily(semibold).color(txtColor).make(),
        20.heightBox,
        ListView.builder(
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: btnColor, width: 2.0)),
                  child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Vx.randomPrimaryColor,
                      child: Image.asset(ic_user, color: Colors.white)),
                ),
                title:
                    "Username".text.fontFamily(semibold).color(txtColor).make(),
                subtitle: "Today, 8:47 PM".text.gray400.make(),
              ),
            );
          },
        )
      ],
    ),
  );
}
