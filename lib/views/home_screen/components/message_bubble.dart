import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/services/store_services.dart';
import 'package:go_blind/views/chat_screen/components/chat_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

Widget messageBubble(DocumentSnapshot doc) {
  var t =
      doc['created_on'] == null ? DateTime.now() : doc['created_on'].toDate();
  var time = intl.DateFormat("h:mm").format(t);
  return FutureBuilder(
    //passing current user id to the function to get the user dcument in firestore
    future: StoreServices.getUser(doc['toId']),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //if data is loaded show the widget
      if (snapshot.hasData) {
        //setting snapshot into a variable for each access
        //here doc[0] because it will contain only one document
        var data = snapshot.data!.docs[0];

        return Card(
          child: ListTile(
            onTap: () {
              Get.to(() => const ChatScreen(),
                  transition: Transition.downToUp,
                  arguments: [
                    doc['friend_name'],
                    doc['toId'],
                  ]);
            },
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: bgColor,
              child: data['image_url'] == ''
                  ? Image.asset(
                      ic_user,
                      color: Colors.white,
                    )
                  : Image.network(
                      data['image_url'],
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAliasWithSaveLayer).make(),
            ),
            title: "${doc['friend_name']}".text.size(16).semiBold.make(),
            subtitle: "${doc['last_msg']}".text.make(),
            trailing: time.text.gray400.make(),
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(bgColor),
          ),
        );
      }
    },
  );
}
