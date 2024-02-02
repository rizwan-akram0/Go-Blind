import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

Widget pickerDialog(context, controller) {
  //setting listicons and titles
  var listTitle = [camera, gallery, cancel];
  var icons = [
    Icons.camera_alt_rounded,
    Icons.photo_size_select_actual_rounded,
    Icons.cancel
  ];
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Container(
      padding: const EdgeInsets.all(12.0),
      color: bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          source.text.fontFamily(semibold).white.make(),
          const Divider(),
          10.heightBox,
          ListView(
            shrinkWrap: true,
            children: List.generate(
              3,
              (index) => ListTile(
                onTap: () {
                  switch (index) {
                    case 0:
                      Get.back();
                      controller.pickImage(context, ImageSource.camera);
                      break;
                    case 1:
                      Get.back();
                      controller.pickImage(context, ImageSource.gallery);
                      break;
                    case 2:
                      Get.back();
                      break;
                  }
                },
                leading: Icon(
                  icons[index],
                  color: Colors.white,
                ),
                title: listTitle[index].text.white.fontFamily(semibold).make(),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
