import 'package:flutter/material.dart';

class ChatMessageOwn extends StatelessWidget {
  ChatMessageOwn({
    Key? key,
    required this.index,
    required this.data,
    this.isShowAvatar = true,
  }) : super(key: key);

  final int index;
  final Map<String, dynamic> data;
  bool isShowAvatar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          child: Text(
            data['message'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
