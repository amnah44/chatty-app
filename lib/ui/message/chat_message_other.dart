import 'package:ffs/util/constants.dart';
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
    return data[Constants.type] == Constants.text
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 8),
              if (isShowAvatar)
                CircleAvatar(
                  backgroundImage: NetworkImage(data[Constants.profileImage]),
                )
              else
                const SizedBox(width: 32),
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
                          data[Constants.auth],
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data[Constants.message],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
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
                            int.parse("${data[Constants.timestamp]}"),
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
      padding: const EdgeInsets.fromLTRB(50, 8, 50, 0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).primaryColorLight,
                border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 2
                )
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: data[Constants.message] != ""
                  ? Image.network(
                data[Constants.message],
                fit: BoxFit.fill,
              )
                  : SpinKitDualRing(
                color: Theme.of(context).primaryColorDark,
                size: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
