import 'package:flutter/material.dart';

class ChatMessageOther extends StatelessWidget {
  ChatMessageOther({
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 8),
        if (isShowAvatar)
          CircleAvatar(
            backgroundImage: NetworkImage(data['profileImage']),
          )
        else
          const SizedBox(width: 39),
        const SizedBox(width: 8),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['auth'],
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data['message'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
