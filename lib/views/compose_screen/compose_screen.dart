import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/services/store_services.dart';
import 'package:go_blind/views/chat_screen/chat.dart';
import 'package:velocity_x/velocity_x.dart';

class ComposeScreen extends StatelessWidget {
  final isCompose;
  const ComposeScreen({super.key, this.isCompose = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: isCompose
          ? AppBar(
              foregroundColor: Colors.white,
              title: "New Message".text.fontFamily(semibold).make(),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          color: Colors.white,
        ),
        child: StreamBuilder(
          stream: StoreServices.getAllUsers(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(bgColor),
                ),
              );
            } else {
              return GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 160,
                ),
                children: snapshot.data!.docs.mapIndexed(
                  (currentValue, index) {
                    var doc = snapshot.data!.docs[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: bgColor.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: doc['image_url'] == ''
                                      ? const AssetImage(ic_user)
                                      : NetworkImage(doc['image_url'])
                                          as ImageProvider,
                                ),
                                20.widthBox,
                                "${doc['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(txtColor)
                                    .make(),
                              ],
                            ),
                            10.heightBox,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  backgroundColor: bgColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(() => const ChatScreen(),
                                      transition: Transition.downToUp,
                                      arguments: [
                                        doc['name'],
                                        doc['id'],
                                      ]);
                                },
                                icon: const Icon(
                                  Icons.message,
                                  color: Colors.white,
                                ),
                                label: "Message".text.white.make(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
