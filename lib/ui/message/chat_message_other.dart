import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

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
    return data['type'] == "text" ?
      Row(
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
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              topLeft: Radius.circular(18),
            ),
          ),
          child: Stack(
            children: [
              Column(
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
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  DateFormat('HH:MM a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse("${data['timestamp']}"),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    )
      : Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: data['message'] != ""
                ? Image.network(
              data['message'],
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width * 0.55,
              height: MediaQuery.of(context).size.height * 0.4,
            )
                : SpinKitDualRing(
              color: Theme.of(context).primaryColorLight,
              size:64,
            ),
          )
        ],
      ),
    );
  }
}
