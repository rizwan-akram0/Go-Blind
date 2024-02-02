import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/services/store_services.dart';
import 'package:go_blind/views/home_screen/components/message_bubble.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:developer';

Widget chatsComponent() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: StreamBuilder(
      stream: StoreServices.getMessages(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          log('no data');
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(bgColor),
            ),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: "Start a conversation"
                .text
                .fontFamily(semibold)
                .color(txtColor)
                .size(16)
                .make(),
          );
        }
        log("Lenght of data is ${snapshot.data!.docs.length}");

        return ListView(
          children: snapshot.data!.docs.mapIndexed(
            (currentValue, index) {
              var doc = snapshot.data!.docs[index];
              log(doc['friend_name']);
              return messageBubble(doc);
            },
          ).toList(),
        );
      },
    ),
  );
}
