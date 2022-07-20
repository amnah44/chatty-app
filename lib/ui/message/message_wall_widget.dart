import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/ui/home/custom_floating_action_buton.dart';
import 'package:ffs/ui/message/chat_message_other.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

import 'chat_message_own.dart';

class MessageWallWidget extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onSwipeMessage;

  MessageWallWidget(
      {Key? key,
      required this.messages,
      required this.onDelete,
      required this.onSwipeMessage})
      : super(key: key);
  final Rx<bool> _isFloatingButtonExtended = false.obs;
  ScrollController listScrollController = ScrollController();

  bool _shouldDisplayAvatar(int index) {
    if (index == 0) return true;

    var previousId = messages[index - 1]['id'];
    var currentId = messages[index]['id'];

    return previousId != currentId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe3eafc),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.minScrollExtent) {
            _isFloatingButtonExtended.value = false;
          } else if (!_isFloatingButtonExtended.value) {
            _isFloatingButtonExtended.value = true;
          }
          return true;
        },
        child: ListView.builder(
          controller: listScrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 8),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (builder, index) {
            final user = FirebaseAuth.instance.currentUser;

            if (user?.uid == messages[index]['id']) {
              return Dismissible(
                onDismissed: (_) => onDelete(messages[index].id),
                key: ValueKey(messages[index]['timestamp']),
                child: ChatMessageOwn(
                  data: messages[index].data() as Map<String, dynamic>,
                  index: index,
                  isShowAvatar: _shouldDisplayAvatar(index),
                ),
              );
            } else {
              return SwipeTo(
                onRightSwipe: () => onSwipeMessage(messages[index].id),
                child: ChatMessageOther(
                  data: messages[index].data() as Map<String, dynamic>,
                  index: index,
                  isShowAvatar: _shouldDisplayAvatar(index),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: Obx(
        () => _isFloatingButtonExtended.value
            ? CustomFloatingActionButton(
                onClick: () {
                  if (listScrollController.hasClients) {
                    final position =
                        listScrollController.position.minScrollExtent;
                    listScrollController.animateTo(
                      position,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  }
                },
              )
            : Container(),
      ),
    );
  }
}
