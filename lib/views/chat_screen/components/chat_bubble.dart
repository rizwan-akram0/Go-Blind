import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/firebase_consts.dart';
import 'package:go_blind/consts/images.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_tts/flutter_tts.dart';

Widget chatBubble(index, DocumentSnapshot doc) {
  FlutterTts flutterTts = FlutterTts();
  speak(String text) async {
    await flutterTts.setLanguage('en-PK');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(3.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  var t =
      doc['created_on'] == null ? DateTime.now() : doc['created_on'].toDate();
  var time = intl.DateFormat("h:mm a").format(t);

  return Directionality(
    textDirection:
        doc['uid'] == user!.uid ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: doc['uid'] == user!.uid ? bgColor : btnColor,
            child: Image.asset(
              ic_user,
              color: Colors.white,
            ),
          ),
          20.widthBox,
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: doc['uid'] == user!.uid ? bgColor : btnColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                // child: Directionality(
                // textDirection: TextDirection.ltr,
                child: "${doc['msg']}".text.fontFamily(semibold).white.make(),
                // ),
              ),
            ),
          ),
          10.widthBox,
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                time.text.color(greyColor).size(12).make(),
                InkWell(
                  onTap: () {
                    speak("${doc['msg']}");
                  },
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: bgColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
