import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key, required this.onSubmit}) : super(key: key);

  final ValueChanged<String> onSubmit;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _controller = TextEditingController();
  var _message;

  void _onPressed() {
    setState(() {});
    widget.onSubmit(_message);
    _controller.clear();
    _message = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 20,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
              decoration: InputDecoration(
                hintText: "Type a message",
                contentPadding: const EdgeInsets.all(8),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: _message == null || _message.isEmpty ? null : _onPressed,
            child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: _message == null || _message.isEmpty
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 32,
                )),
          )
        ],
      ),
    );
  }
}
