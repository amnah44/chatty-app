import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

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
    return data['type'] == "text"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data['message'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        DateFormat('HH:MM a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse("${data['timestamp']}"),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(width: 16),
            ],
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Stack(
              alignment: Alignment.centerRight,
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
                          size: 40,
                        ),
                )
              ],
            ),
          );
  }
}
