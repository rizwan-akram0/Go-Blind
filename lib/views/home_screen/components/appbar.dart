import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/services/store_services.dart';
import 'package:velocity_x/velocity_x.dart';

Widget appbar(GlobalKey<ScaffoldState> key) {
  return FutureBuilder(
    //passing current user id to the function to get the user dcument in firestore
    future: StoreServices.getUser(user!.uid),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //if data is loaded show the widget
      if (snapshot.hasData) {
        //setting snapshot into a variable for each access
        //here doc[0] because it will contain only one document
        var data = snapshot.data!.docs[0];

        return Container(
          padding: const EdgeInsets.only(right: 12.0),
          color: Colors.white,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  key.currentState!.openDrawer();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100.0),
                      bottomRight: Radius.circular(100.0),
                    ),
                    color: bgColor,
                  ),
                  height: 80,
                  width: 90,
                  child: const Icon(
                    settingsIcon,
                    color: Colors.white,
                  ),
                ),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "$appname\n",
                      style: TextStyle(
                        fontFamily: bold,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "                    $connectingLives",
                      style: TextStyle(
                        fontFamily: "lato",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Vx.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: bgColor,
                radius: 25,
                child: data['image_url'] == ''
                    ? Image.asset(
                        ic_user,
                        color: Colors.white,
                      )
                    : Image.network(
                        data['image_url'],
                        fit: BoxFit.cover,
                      )
                        .box
                        .roundedFull
                        .clip(Clip.antiAliasWithSaveLayer)
                        .make(),
              ),
            ],
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
