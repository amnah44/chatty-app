import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/util/direction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key, required this.onSubmit}) : super(key: key);

  final ValueChanged<String> onSubmit;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final ValueNotifier<TextDirection> _textDir =
      ValueNotifier(TextDirection.ltr);
  final _controller = TextEditingController();
  var _message;

  void _onPressed() {
    setState(() {});
    widget.onSubmit(_message);
    _controller.clear();
    _message = "";
  }

  File? imageFile;

  Future getImage() async {
    ImagePicker _image = ImagePicker();

    await _image.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    var user = FirebaseAuth.instance.currentUser;
    String fileName = Uuid().v1();
    int status = 1;

    if (user != null) {
      await firebaseFirestore.collection('chatty').doc(fileName).set({
        'auth': user.displayName ?? "",
        'id': user.uid,
        'phonenumber': user.phoneNumber ?? "",
        'type': "image",
        'timestamp': Timestamp.now().millisecondsSinceEpoch,
        'profileImage': user.photoURL ??
            "https://avatars.githubusercontent.com/u/59895284?v=4",
        'message': fileName,
      });
    }
    var ref =
        FirebaseStorage.instance.ref().child("image").child("$fileName.jpg");

    var upload = await ref.putFile(imageFile!).catchError((error) async {
      await firebaseFirestore.collection('chatty').doc(fileName).delete();
      status = 0;

      print("mmmmmmmmmmmmmmmmm $error");
    });

    if (status == 1) {
      String imageUrl = await upload.ref.getDownloadURL();
      await firebaseFirestore
          .collection('chatty')
          .doc(fileName)
          .update({'message': imageUrl});

      print("mmmmmmmmmmmmmmmmm $imageUrl");
    }
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
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.photo,
                        color: Colors.blue,
                        size: 32,
                      ),
                      onPressed: () => getImage(),
                    )),
                textDirection: value,
                controller: _controller,
                onChanged: (input) {
                  setState(() {
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

/*

 */
