import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'dart:developer';
import 'package:velocity_x/velocity_x.dart';

class ChatController extends GetxController {
  //variables for chat
  dynamic chatId;
  var chats = firebaseFirestore.collection(collectionChats);
  var userId = user!.uid;
  //get this through argument
  var friendId = Get.arguments[1];
  var username = '';
  //it will get the name from the prefs 0 index
  // var username =
  //     HomeController.instance.prefs.getStringList('user_details')![0];

  //get this through argument
  var friendname = Get.arguments[0];

  //text Controller
  var messageController = TextEditingController();

  var isLoading = false.obs;

  //creating chatscreen
  getChatId() async {
    isLoading(true);
    await firebaseFirestore
        .collection(collectionUser)
        .where('id', isEqualTo: user!.uid)
        .get()
        .then((value) async {
      username = value.docs[0]['name'];
    });
    log(username);
    await chats
        .where('users', isEqualTo: {friendId: null, userId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot snapshot) async {
            if (snapshot.docs.isNotEmpty) {
              //if chatroom is already created then get the chat id
              chatId = snapshot.docs.single.id;
            } else {
              //if chatroom is not created then create a new chatroom
              await chats.add(
                {
                  'users': {userId: null, friendId: null},
                  'friend_name': friendname,
                  'user_name': username,
                  'toId': '',
                  'fromId': '',
                  'created_on': null,
                  'last_msg': '',
                },
              ).then(
                (value) {
                  //assign the doc id to our chatId variable
                  {
                    chatId = value.id;
                  }
                },
              );
            }
          },
        );
    isLoading(false);
  }

  sendMessage(String msg) {
    if (msg.trim().isNotEmptyAndNotNull) {
      chats.doc(chatId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': userId,
      });
      //now save the message in the chatroom
      chats.doc(chatId).collection(collectionMessages).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': userId,
      }).then((value) {
        messageController.clear();
      }); 
    }
  }

  @override
  void onInit() {
    getChatId();
    super.onInit();
  }
}
