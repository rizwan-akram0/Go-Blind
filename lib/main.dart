import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/views/home_screen/home_screen.dart';
import 'package:go_blind/views/signin_screen/signin_screen.dart';
import 'package:velocity_x/velocity_x.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyCgD-UfDpP5ygpX0x5-XoCtg6UwRLqqESU',
            appId: '1:891298650823:android:ccaf87e3a2dc53efaffce2',
            messagingSenderId: '891298650823',
            projectId: 'goblind-2',
          ),
        )
      : await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isUser = false;

  checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        setState(() {
          isUser = false;
        });
      } else {
        setState(() {
          isUser = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
     
    return GetMaterialApp(
        
        theme: ThemeData(fontFamily: "lato"),
        debugShowCheckedModeBanner: false,
       
        home: isUser ? const HomeScreen() : const ChatApp(),
        title: appname,
      
    );
  }
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    logo,
                    width: 120,
                  ),
                  appname.text.size(32).fontFamily(bold).make(),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10.0,
                    children: List.generate(
                      listOfFeatures.length,
                      (index) {
                        return Chip(
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 4),
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(color: Vx.gray400),
                            shape: const StadiumBorder(),
                            label: listOfFeatures[index].text.gray600.make());
                      },
                    ),
                  ),
                  20.heightBox,
                  slogan.text
                      .size(38)
                      .fontFamily(bold)
                      .letterSpacing(2.0)
                      .make(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(
                    width: context.screenWidth - 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: bgColor,
                            shape: const StadiumBorder()),
                        onPressed: () {
                          Get.to(const SigninScreen(),
                              transition: Transition.downToUp);
                        },
                        child: cont.text.semiBold.size(16).white.make()),
                  ),
                  10.heightBox,
                  poweredby.text.size(15).gray600.make(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
