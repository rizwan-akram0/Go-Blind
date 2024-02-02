import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var aboutController = TextEditingController();

  //variables for image picker
  var imgpath = ''.obs;
  var imglink = ''.obs;

  //update profile method

  updateProfile(context) async {
    //setting store variable to the document of our current user
    var store = firebaseFirestore.collection(collectionUser).doc(user!.uid);

    // update the data
    await store.set({
      'name': nameController.text.toString(),
      'about': aboutController.text.toString(),
      //phone number can't be changed,

      'image_url': imglink.value.toString(),
    }, SetOptions(merge: true));
    //show toast when done
    Get.snackbar("Success", "Profile updated successfully");
  }

  //pick image method
  // pickImage(context, source) async {
  //   //get permission from user
  //   await Permission.photos.request();
  //   await Permission.camera.request();
  //   await Permission.storage.request();
  //   //getting status of out permission to handle

  //   var status = await Permission.photos.status;

  //   //handle status
  //   if (status.isGranted) {
  //     //if granted show picker dialog
  //     try {
  //       final img =
  //           await ImagePicker().pickImage(source: source, imageQuality: 80);
  //       imgpath.value = img!.path;
  //       VxToast.show(context, msg: "Image selected");
  //     } on PlatformException catch (e) {
  //       Get.snackbar("Error", e.toString());
  //     }
  //   } else {
  //     //if not granted show snackbar
  //     Get.snackbar("Error", "Permission denied");
  //     await Permission.photos.request();
  //     await Permission.camera.request();
  //     await Permission.storage.request();

  //     status = await Permission.photos.status;

  //     log('inside else ${status.isGranted}');
  //   }
  // }

  pickImage(context, source) async {
    // Request permissions

    await Permission.photos.request();
    final PermissionStatus status = await Permission.camera.request();
    await Permission.storage.request();

    // var status = await Permission.camera.status;
    // Check permission status

    log('inside pick image ${status.isGranted}');

    // Handle status
    if (status.isGranted) {
      // Show picker dialog
      try {
        final img =
            await ImagePicker().pickImage(source: source, imageQuality: 80);

        if (img == null) {
          // User canceled image selection
          return;
        }

        imgpath.value = img.path;
        VxToast.show(context, msg: "Image selected");
      } on PlatformException catch (e) {
        Get.snackbar("Error", e.toString());
      }
    } else {
      if (status.isPermanentlyDenied) {
        // Guide user to app settings
        openAppSettings();
      }
      // Handle denied or permanently denied
      Get.snackbar("Error", "Permission denied");
    }
  }

  //upload image method
  uploadImage() async {
    var name = basename(imgpath.value);
    var destination = 'images/${user!.uid}/$name';
    Reference ref = FirebaseStorage.instanceFor(bucket: "goblind-2.appspot.com").ref().child(destination);

    await ref.putFile(File(imgpath.value));

    imglink.value = await ref.getDownloadURL();
  }
}
