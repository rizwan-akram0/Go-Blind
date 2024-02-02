import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/views/home_screen/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController {
  //text controller
  var usernameController = TextEditingController();
  var phoneController = TextEditingController();
  var otpController = List.generate(6, (index) => TextEditingController());

  //variables
  var isOtpSent = false.obs;
  var formKey = GlobalKey<FormState>();

  //auth variables
  late final PhoneVerificationCompleted phoneVerificationCompleted;
  late final PhoneVerificationFailed phoneVerificationFailed;
  late final PhoneCodeSent phoneCodeSent;
  String verificationID = "";

  //sendOtp method
  sendOtp() async {
    phoneVerificationCompleted = (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };
    phoneVerificationFailed = (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        Get.snackbar("Error", "Invalid Phone Number");
      } else {
        Get.snackbar("Error", e.message.toString());
      }
    };
    phoneCodeSent = (String verificationId, int? resendToken) {
      verificationID = verificationId;
      // isOtpSent.value = true;
    };
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+92${phoneController.text}",
          verificationCompleted: phoneVerificationCompleted,
          verificationFailed: phoneVerificationFailed,
          codeSent: phoneCodeSent,
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  //verifyOtp method
  verifyOtp(context) async {
    String otp = "";
    //getting otp from text controllers
    for (var i = 0; i < otpController.length; i++) {
      otp += otpController[i].text;
    }
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otp);
      //getting user
      final User? user =
          (await auth.signInWithCredential(phoneAuthCredential)).user;
      if (user != null) {
        //store user data in firestore
        DocumentReference store =
            firebaseFirestore.collection(collectionUser).doc(user.uid);

        await store.set(
          {
            'id': user.uid,
            'name': usernameController.text.toString(),
            'phone': phoneController.text.toString(),
            'about': 'Hey there! I am using Go Blind.',
            'image_url': '',
            'createdAt': DateTime.now(),
          },
          SetOptions(merge: true),
        );
        VxToast.show(context, msg: loggedin);
        Get.offAll(() => const HomeScreen(), transition: Transition.downToUp);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
