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
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomRight: Radius.zero,
              topLeft: Radius.circular(50),
            ),
          ),
          child: Text(
            data['message'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
