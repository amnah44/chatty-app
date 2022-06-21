import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/ui/message/chat_message_other.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'chat_message_own.dart';

class MessageWallWidget extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  final ValueChanged<String> onDelete;

  const MessageWallWidget({
    Key? key,
    required this.messages,
    required this.onDelete,
  }) : super(key: key);

  bool _shouldDisplayAvatar(int index) {
    if (index == 0) return true;

    var previousId = messages[index - 1]['id'];
    var currentId = messages[index]['id'];

    return previousId != currentId;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
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
          return ChatMessageOther(
            data: messages[index].data() as Map<String, dynamic>,
            index: index,
            isShowAvatar: _shouldDisplayAvatar(index),
          );
        }
      },
    );
  }
}
