import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_blind/consts/colors.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:go_blind/controllers/chats_controller.dart';
import 'package:go_blind/services/store_services.dart';
import 'package:go_blind/views/chat_screen/components/chat_bubble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var controller = Get.put(ChatController());

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      default:
        log("Permission not granted");
        break;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_En",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      controller.messageController.text = _lastWords;
      log(controller.messageController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.0)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${controller.friendname}\n",
                            style: const TextStyle(
                                fontFamily: semibold,
                                fontSize: 16.0,
                                color: Vx.black),
                          ),
                          const TextSpan(
                            text: "Last seen",
                            style: TextStyle(
                                fontFamily: semibold,
                                fontSize: 12.0,
                                color: Vx.gray400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: btnColor,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.video_call_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  10.widthBox,
                  CircleAvatar(
                    backgroundColor: btnColor,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            30.heightBox,
            Obx(
              () => Expanded(
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(bgColor),
                        ),
                      )
                    : StreamBuilder(
                        stream: StoreServices.getChats(controller.chatId),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(bgColor),
                              ),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!.docs
                                  .mapIndexed((currentValue, index) {
                                var doc = snapshot.data!.docs[index];
                                return chatBubble(index, doc);
                              }).toList(),
                            );
                          }
                        },
                      ),
              ),
            ),
            10.heightBox,
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: controller.messageController,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.emoji_emotions_rounded,
                            color: greyColor,
                          ),
                          // suffixIcon: InkWell(
                          //   onTap: () {},
                          //   child: const Icon(
                          //     Icons.attachment_rounded,
                          //     color: greyColor,
                          //   ),
                          // ),
                          border: InputBorder.none,
                          hintText: "Type message here...",
                          hintStyle: TextStyle(
                            fontFamily: semibold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  10.widthBox,
                  GestureDetector(
                    onTap: () {
                      controller.sendMessage(controller.messageController.text);
                      _lastWords = "";
                      controller.messageController.clear();
                    },
                    child: const CircleAvatar(
                      backgroundColor: btnColor,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FloatingActionButton.small(
                    shape: const CircleBorder(),
                    onPressed:
                        // If not yet listening for speech start, otherwise stop
                        _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                    tooltip: 'Listen',
                    backgroundColor: btnColor,
                    child: Icon(
                      _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
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
}
