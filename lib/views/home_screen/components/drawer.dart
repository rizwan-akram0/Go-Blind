import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/main.dart';
import 'package:go_blind/services/store_services.dart';
import 'package:go_blind/views/compose_screen/compose_screen.dart';
import 'package:go_blind/views/help_screen/help_screen.dart';
import 'package:go_blind/views/profile_screen/profile_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

Widget drawer() {
  // var controller = Get.put(ProfileController());

  return Drawer(
    backgroundColor: bgColor,
    shape: const RoundedRectangleBorder(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ).onTap(
              () {
                Get.back();
              },
            ),
            title: settings.text.fontFamily(semibold).white.make(),
          ),
          20.heightBox,
          FutureBuilder(
            //passing current user id to the function to get the user dcument in firestore
            future: StoreServices.getUser(user!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //if data is loaded show the widget
              if (snapshot.hasData) {
                //setting snapshot into a variable for each access
                //here doc[0] because it will contain only one document
                var data = snapshot.data!.docs[0];

                return Column(children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: bgColor,
                    child: data['image_url'] == ''
                        ? Image.asset(
                            ic_user,
                            color: Colors.white,
                          )
                        : Image.network(
                            data['image_url'],
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                  ),
                  20.heightBox,
                  "${data['name']}"
                      .text
                      .white
                      .fontFamily(semibold)
                      .size(16)
                      .make(),
                  20.heightBox,
                  const Divider(
                    color: greyColor,
                    height: 1,
                  ),
                  20.heightBox,
                  ListView(
                    shrinkWrap: true,
                    children: List.generate(
                      drawerIconsList.length,
                      (index) => ListTile(
                        onTap: () async {
                          switch (index) {
                            case 0:
                              Get.to(() => const ProfileScreen(),
                                  transition: Transition.downToUp);
                              break;
                            case 1:
                              Get.to(() => const ComposeScreen(),
                                  transition: Transition.downToUp);
                              break;
                            case 2:
                              await openAppSettings();
                              break;
                            case 3:
                              Get.to(() => const HelpScreen(),
                                  transition: Transition.downToUp);
                            default:
                          }
                        },
                        leading: Icon(
                          drawerIconsList[index],
                          color: Colors.white,
                        ),
                        title: drawerListTitles[index]
                            .text
                            .white
                            .fontFamily(semibold)
                            .size(16)
                            .make(),
                      ),
                    ),
                  ),
                  10.heightBox,
                  const Divider(
                    color: greyColor,
                    height: 1,
                  ),
                  10.heightBox,
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      inviteIcon,
                      color: Colors.white,
                    ),
                    title: invite.text.fontFamily(semibold).white.make(),
                  ),
                ]);
              }
              //if data is not loaded show the circular progress indicator
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const Spacer(),
          ListTile(
            onTap: () async {
              await auth.signOut().then((value) {
                Get.offAll(() => const ChatApp(),
                    transition: Transition.downToUp);
              });
              // Get.offAll(() => const ChatApp(),
              //     transition: Transition.downToUp);
            },
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            title: logout.text.fontFamily(semibold).white.make(),
          ),
        ],
      ),
    ),
  );
}
