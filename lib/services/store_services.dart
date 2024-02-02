import 'package:go_blind/consts/firebase_consts.dart';

class StoreServices {
  //get user data
  static getUser(String id) {
    return firebaseFirestore
        .collection(collectionUser)
        .where('id', isEqualTo: id)
        .get();
  }

  //get all users from our firestore collecztion
  static getAllUsers() {
    return firebaseFirestore.collection(collectionUser).snapshots();
  }

  static getChats(String chatId) {
    return firebaseFirestore
        .collection(collectionChats)
        .doc(chatId)
        .collection(collectionMessages)
        .orderBy('created_on', descending: true)
        .snapshots();
  }

  static getMessages() {
    return firebaseFirestore
        .collection(collectionChats)
        .where("users.${user!.uid}", isEqualTo: null)
        // .where('fromId', isEqualTo: user!.uid)
        // .where("created_on", isNotEqualTo: null)
        // .orderBy('created_on', descending: true)
        .snapshots();

    // return firebaseFirestore
    //     .collection(collectionChats)
    //     .where(Filter.or(Filter('fromId', isEqualTo: user!.uid),
    //         Filter('toId', isEqualTo: user!.uid)))
    //     .snapshots();
  }
}
