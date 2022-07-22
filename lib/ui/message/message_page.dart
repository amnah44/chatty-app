import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/api/firebase_api.dart';
import 'package:ffs/util/constants.dart';
import 'package:ffs/util/direction.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key, required this.onSubmit, required this.focusNode})
      : super(key: key);

  final ValueChanged<String> onSubmit;
  final FocusNode focusNode;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final ValueNotifier<TextDirection> _textDir =
      ValueNotifier(TextDirection.ltr);
  final _controller = TextEditingController();
  final FirebaseApi firebaseApi = FirebaseApi();
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
        children: [
          Expanded(
            child: ValueListenableBuilder<TextDirection>(
              valueListenable: _textDir,
              builder: (context, value, child) => TextField(
                focusNode: widget.focusNode,
                minLines: 1,
                maxLines: 20,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
                decoration: InputDecoration(
                    hintText: Constants.typeMessage,
                    contentPadding: const EdgeInsets.all(8),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.photo,
                        color: Colors.blue,
                        size: 32,
                      ),
                      onPressed: () => firebaseApi.getImage(),
                    )),
                textDirection: value,
                controller: _controller,
                onChanged: (input) {
                  setState(() async{
                    if(_message != null || _message != ""){
                      await firebaseFirestore.doc(Constants.chatty).update({Constants.isTyping: 'true'});
                    }
                    _message = input;
                    if (_message.trim().length < 2) {
                      final dir = Direction.getDirection(_message);
                      if (dir != value) _textDir.value = dir;
                    }
                  });
                },
              ),
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
