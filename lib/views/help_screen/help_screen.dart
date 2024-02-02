import 'package:flutter/material.dart';
import 'package:go_blind/consts/strings.dart';
import 'package:go_blind/consts/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                welcome.text.fontFamily(bold).size(22).make(),
                20.heightBox,
                gettingStarted.text.fontFamily(semibold).size(18).make(),
                10.heightBox,
                accountCreation.text.fontFamily(semibold).size(16).make(),
                'To start using Go Blind, you need to create an account. Follow these steps:'
                    .text
                    .fontFamily(light)
                    .make(),
                5.heightBox,
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '1.  Download and install the Go Blind Chat App from the App Store or Google Play Store.'
                          .text
                          .fontFamily(light)
                          .make(),
                      '2.  Open the app and tap on the "Sign Up" button.'
                          .text
                          .fontFamily(light)
                          .make(),
                      '3.  Enter your phone number to recieve an otp.'
                          .text
                          .fontFamily(light)
                          .make(),
                      '4.  Complete the account verification process.'
                          .text
                          .fontFamily(light)
                          .make(),
                    ],
                  ),
                ),
                10.heightBox,
                navigateApp.text.fontFamily(semibold).size(18).make(),
                10.heightBox,
                chatInterface.text.fontFamily(semibold).size(16).make(),
                "The main screen of Go Blind is the chat interface. Here's how to navigate it:"
                    .text
                    .fontFamily(light)
                    .make(),
                5.heightBox,
                Row(
                  children: [
                    'Chats: '.text.fontFamily(semibold).make(),
                    'All your active conversations are displayed here.'
                        .text
                        .fontFamily(light)
                        .make()
                  ],
                ),
                Row(
                  children: [
                    'Friends: '.text.fontFamily(semibold).make(),
                    'Access contacts to start new conversations.'
                        .text
                        .fontFamily(light)
                        .make()
                  ],
                ),
                10.heightBox,
                startChat.text.fontFamily(semibold).size(16).make(),
                'To begin a new chat:'.text.fontFamily(light).make(),
                5.heightBox,
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '1.  Tap on the "Contacts" tab.'
                          .text
                          .fontFamily(light)
                          .make(),
                      '2.  Select a contact from your list.'
                          .text
                          .fontFamily(light)
                          .make(),
                      '3.  Tap on the "Chat" button to start a conversation.'
                          .text
                          .fontFamily(light)
                          .make(),
                    ],
                  ),
                ),
                10.heightBox,
                sendMessage.text.fontFamily(semibold).size(16).make(),
                5.heightBox,
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '1.  To send a text message, tap the message input field, type your message, and press "Send."'
                          .text
                          .fontFamily(light)
                          .make(),
                      '2.  To send a voice message as text message, tap and hold the microphone icon, and begin speaking.'
                          .text
                          .fontFamily(light)
                          .make(),
                      '3.  Tap the send button to send the voice message as text message.'
                          .text
                          .fontFamily(light)
                          .make(),
                    ],
                  ),
                ),
                10.heightBox,
                updates.text.fontFamily(semibold).size(18).make(),
                'We continuously strive to improve Go Blind Chat App. Keep your app updated to access the latest features and improvements. We appreciate your feedback—send your suggestions or report issues through the app or our support channels.'
                    .text
                    .fontFamily(light)
                    .make(),
                15.heightBox,
                'Thank you for using Go Blind Chat App!'
                    .text
                    .fontFamily(semibold)
                    .makeCentered(),
                10.heightBox,
              ],
            ),
          ),
        ));
  }
}
