import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/controllers/auth_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: letsconnect.text.black.fontFamily(bold).make(),
        ),
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    //username field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username is required";
                        } else if (value.length < 3) {
                          return "Isername must be atleast 3 characters long";
                        }
                        return null;
                      },
                      controller: controller.usernameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Vx.gray400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Vx.gray400),
                        ),
                        labelText: "Username",
                        prefixIcon: const Icon(
                          Icons.person_rounded,
                          color: Vx.gray600,
                        ),
                        hintText: "e.g. John Doe",
                        alignLabelWithHint: true,
                        labelStyle: const TextStyle(
                            color: Vx.gray600, fontWeight: FontWeight.bold),
                      ),
                    ),
                    10.heightBox,
                    //phone number field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone Number is required";
                        } else if (value.length < 10) {
                          return "Phone Number is invalid";
                        }
                        return null;
                      },
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Vx.gray400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Vx.gray400),
                        ),
                        labelText: "Phone Number",
                        prefixText: "+92",
                        prefixIcon: const Icon(
                          Icons.phone_android_rounded,
                          color: Vx.gray600,
                        ),
                        hintText: " 3121234567",
                        alignLabelWithHint: true,
                        labelStyle: const TextStyle(
                            color: Vx.gray600, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              10.heightBox,
              otp.text.semiBold.size(16).gray600.make(),

              //otp field,
              Obx(
                () => Visibility(
                  visible: controller.isOtpSent.value,
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 56,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: controller.otpController[index],
                            cursorColor: bgColor,
                            onChanged: (value) {
                              if (value.length == 1 && index <= 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: bold,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(color: Vx.gray400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(color: Vx.gray400),
                              ),
                              hintText: "*",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: context.screenWidth - 80,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: bgColor,
                          shape: const StadiumBorder()),
                      onPressed: () async {
                        if (controller.formKey.currentState!.validate()) {
                          if (controller.isOtpSent.value == false) {
                            controller.isOtpSent.value = true;
                            await controller.sendOtp();
                          } else {
                            await controller.verifyOtp(context);
                          }
                        }
                      },
                      child: continueText.text.semiBold.size(16).white.make()),
                ),
              ),
              30.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
