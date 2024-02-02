import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/controllers/profile_controller.dart';
import 'package:go_blind/services/store_services.dart';
import 'package:go_blind/views/profile_screen/components/picker_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // init profile controller
    var controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.white,
        title: profile.text.fontFamily(bold).white.make(),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.imgpath.value.isEmpty) {
                controller.updateProfile(context);
              } else {
                await controller.uploadImage();
                controller.updateProfile(context);
              }
            },
            child: 'Save'.text.white.fontFamily(semibold).make(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12.0),
          //init FutureBuilder
          child: FutureBuilder(
            //passing current user id to the function to get the user dcument in firestore
            future: StoreServices.getUser(user!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //if data is loaded show the widget
              if (snapshot.hasData) {
                //setting snapshot into a variable for each access
                //here doc[0] because it will contain only one document
                var data = snapshot.data!.docs[0];

                //setting values to text containers
                controller.nameController.text = data['name'];
                controller.phoneController.text = data['phone'];
                controller.aboutController.text = data['about'];

                return Column(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 80,
                        backgroundColor: bgColor,
                        child: Stack(
                          children: [
                            //if image is selected then show the image,
                            //else show the default image
                            controller.imgpath.isEmpty &&
                                    data['image_url'] == ''
                                ? Image.asset(
                                    ic_user,
                                    color: Colors.white,
                                  )
                                : controller.imgpath.isNotEmpty
                                    ? Image.file(
                                        File(controller.imgpath.value),
                                        fit: BoxFit.cover,
                                      )
                                        .box
                                        .roundedFull
                                        .clip(Clip.antiAlias)
                                        .make()
                                    : Image.network(
                                        data['image_url'],
                                        fit: BoxFit.cover,
                                      )
                                        .box
                                        .roundedFull
                                        .clip(Clip.antiAlias)
                                        .make(),
                            Positioned(
                              right: 0,
                              bottom: 20,
                              child: CircleAvatar(
                                backgroundColor: bgColor,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ).onTap(() {
                                  Get.dialog(pickerDialog(context, controller));
                                }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    20.heightBox,
                    const Divider(
                      color: bgColor,
                      height: 1,
                    ),
                    10.heightBox,
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: TextFormField(
                        controller: controller.nameController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: "Name".text.white.fontFamily(semibold).make(),
                          isDense: true,
                          labelStyle: const TextStyle(
                              color: Colors.white, fontFamily: semibold),
                        ),
                      ),
                      subtitle:
                          namesub.text.gray400.fontFamily(semibold).make(),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title: TextFormField(
                        controller: controller.aboutController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: "About".text.white.fontFamily(semibold).make(),
                          isDense: true,
                          labelStyle: const TextStyle(
                              color: Colors.white, fontFamily: semibold),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.call, color: Colors.white),
                      title: TextFormField(
                        controller: controller.phoneController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        readOnly: true,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: "Phone".text.white.fontFamily(semibold).make(),
                          isDense: true,
                          labelStyle: const TextStyle(
                              color: Colors.white, fontFamily: semibold),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                // if data is not loaded yet then show progress indicator
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
