import 'package:get/get.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class HomeController extends GetxController {
  late SharedPreferences prefs;

  var isProfile = true.obs;

  //creating a variable to access home controller variables in other controllers
  static HomeController instance = Get.find();

  getUserDetails() async {
    log('getting user details');

    log('message');
    //getting user details from firestore
    await firebaseFirestore
        .collection(collectionUser)
        .where('id', isEqualTo: user!.uid)
        .get()
        .then((value) async {
      prefs = await SharedPreferences.getInstance();
      log('user details fetched');
      prefs.setStringList('user_details', [
        value.docs[0]['name'],
        value.docs[0]['image_url'],
      ]);
    });
  }

  //execute when controller is initialized
  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }
}
